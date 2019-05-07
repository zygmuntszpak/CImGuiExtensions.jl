mutable struct CSVImporter{T <: AbstractSchema} <: AbstractImporter
    isenabled::Bool
    schema::T
end

function isenabled(importer::CSVImporter)
    return importer.isenabled
end

function enable!(importer::CSVImporter)
    importer.isenabled = true
end

function disable!(importer::CSVImporter)
    importer.isenabled  = false
end

function (load::CSVImporter{<:AbstractSchema})(path::Path)
    @show "Inside generic CSV importer..."
    disable!(load)
    path₁ = joinpath(get_directory(path), get_filename(path))
    data = nothing
    if is_readable_file(path₁)
        try
            data = CSV.File(path₁) |> DataFrame
        catch e
            println(e)
            CImGui.OpenPopup("Has the file been corrupted?")
        end
    else
        CImGui.OpenPopup("Do you have permission to read the file?")
    end

    if CImGui.BeginPopupModal("Has the file been corrupted?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
        CImGui.Text("Unable to open the specified file.\nPlease verify that: \n   (1) the file has not been corrupted; \n   (2) you have permission to access the file.\n\n")
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
    data
end

struct ImportContext{T₁ <: AbstractDialogControl,   T₂ <: AbstractDialogModel,  T₃ <: AbstractDisplayProperties, T₄ <: Union{AbstractImporter}} <: AbstractContext
    control::T₁
    model::T₂
    display_properties::T₃
    action::T₄
end


function (context::ImportContext)()
        control = context.control
        model = context.model
        display_properties = context.display_properties
        action = context.action
        isenabled(control) ? control(model, display_properties, action) : nothing
        data = isenabled(action) ? action(get_path(model, ConfirmedStatus())) : nothing
end

function isrunning(context::ImportContext)
        isenabled(context.control) || isenabled(context.action)
end
