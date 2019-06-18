struct GenericVendor <: AbstractVendor end
struct GenericProduct <: AbstractProduct end

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
    disable!(load)
    load_dataframe(path)
end

function load_dataframe(path::Path)
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
    handle_import_error_messages()
    data
end

function load_dataframe(path::Path, header::Vector{String})
    path₁ = joinpath(get_directory(path), get_filename(path))
    data = nothing
    if is_readable_file(path₁)
        try
            data = CSV.File(path₁; header = header) |> DataFrame
        catch e
            println(e)
            CImGui.OpenPopup("Has the file been corrupted?")
        end
    else
        CImGui.OpenPopup("Do you have permission to read the file?")
    end
    handle_import_error_messages()
    data
end

function handle_import_error_messages()
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

    if CImGui.BeginPopupModal("Have you opened the appropriate file?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
    CImGui.Text("The file format does not to conform to the expected schema.\nPlease verify that the data in the file follows the expected convention.\n\n")
    CImGui.Separator()
    CImGui.Button("OK", (120, 0)) && CImGui.CloseCurrentPopup()
    CImGui.SetItemDefaultFocus()
    CImGui.EndPopup()
    end
end
