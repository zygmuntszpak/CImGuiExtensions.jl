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

function (store::CSVExporter{<:AbstractSchema})(path::Path, data::DataFrame)
    disable!(store)
    path₁ = joinpath(get_directory(path), get_filename(path))
    # We are trying to create a new file.
    if !is_queryable_file(path₁)
        try
            CSV.write(path₁, data)
        catch e
            println(e)
            CImGui.OpenPopup("Do you have permission to create the file?")
        end
    # We are modifying an existing file.
    elseif is_writeable_file(path₁)
        try
            CSV.write(path₁, data)
        catch e
            println(e)
            CImGui.OpenPopup("Do you have permission to modify the file?")
        end
    else
        CImGui.OpenPopup("Do you have permission to modify the file?")
    end
    handle_export_error_messages()

end

function handle_export_error_messages()
    if CImGui.BeginPopupModal("Do you have permission to create the file?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
        CImGui.Text("Unable to write to the specified file.\nPlease verify that you have permission to create the file.\n\n")
        CImGui.Separator()
        CImGui.Button("OK", (120, 0)) && CImGui.CloseCurrentPopup()
        CImGui.SetItemDefaultFocus()
        CImGui.EndPopup()
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
