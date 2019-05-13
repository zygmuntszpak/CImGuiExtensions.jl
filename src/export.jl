mutable struct CSVExporter{T <: AbstractSchema} <: AbstractExporter
    isenabled::Bool
    schema::T
end

function isenabled(exporter::CSVExporter)
    return exporter.isenabled
end

function enable!(exporter::CSVExporter)
    exporter.isenabled = true
end

function disable!(exporter::CSVExporter)
    exporter.isenabled  = false
end

struct ExportContext{T₁ <: AbstractDialogControl,   T₂ <: AbstractDialogModel,  T₃ <: AbstractDisplayProperties, T₄ <: Union{AbstractExporter}} <: AbstractContext
    control::T₁
    model::T₂
    display_properties::T₃
    action::T₄
end

function (store::CSVExporter{<:AbstractSchema})(path::Path, data::DataFrame)
    @show "Inside generic CSV exporter..."
    disable!(store)
    path₁ = joinpath(get_directory(path), get_filename(path))
    if is_writeable_file(path₁)
        try
            CSV.write(path₁, data)
        catch e
            println(e)
            CImGui.OpenPopup("Do you have permission to modify the file?")
        end
    else
        CImGui.OpenPopup("Do you have permission to modify the file?")
    end

    if CImGui.BeginPopupModal("Do you have permission to modify the file?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
        CImGui.Text("Unable to write to the specified file.\nPlease verify that: \n   (1) the file exists; \n   (2) you have permission to modify the file.\n\n")
        CImGui.Separator()
        CImGui.Button("OK", (120, 0)) && CImGui.CloseCurrentPopup()
        CImGui.SetItemDefaultFocus()
        CImGui.EndPopup()
    end

    if CImGui.BeginPopupModal("Do you have permission to read the file?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
        CImGui.Text("Unable to access the specified file.\nPlease verify that: \n   (1) the file exists; \n   (2) you have permission to read the file.\n\n")
        CImGui.Separator()
        CImGui.Button("OK", (120, 0)) && CImGui.CloseCurrentPopup()
        CImGui.SetItemDefaultFocus()
        CImGui.EndPopup()
    end
end

function (context::ExportContext)(data::DataFrame)
        control = context.control
        model = context.model
        display_properties = context.display_properties
        action = context.action
        isenabled(control) ? control(model, display_properties, action) : nothing
        isenabled(action) ? action(get_path(model, ConfirmedStatus()), data) : nothing
end

function isrunning(context::ExportContext)
        isenabled(context.control) || isenabled(context.action)
end
