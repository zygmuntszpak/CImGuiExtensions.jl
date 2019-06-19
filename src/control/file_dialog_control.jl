mutable struct FileDialogControl <: AbstractDialogControl
    isenabled::Bool
end

function (control::FileDialogControl)(model::FileDialogModel, properties::AbstractDisplayProperties, operation::AbstractOperation)
    CImGui.SetNextWindowSize(ImVec2(get_width(properties), get_height(properties)))
    @c CImGui.Begin(get_caption(properties), &control.isenabled)
        facilitate_path_selection!(model)
        facilitate_directory_file_selection!(model)
        handle_cancellation_confirmation!(control, model,  get_action(properties), operation)
        handle_file_error_messaging()
    CImGui.End()
end

function facilitate_path_selection!(model::FileDialogModel)
    path = get_path(model,  UnconfirmedStatus())
    path_directories = splitpath(get_directory(path))
    selected_directory = Cint(length(path_directories))
    # Draw a button for each directory that constitutes the current path.
    for (index, d) in enumerate(path_directories)
        CImGui.Button(d) && (selected_directory = Cint(index);)
        CImGui.SameLine()
    end
    # If a button is clicked then we keep only the directories up-to and including the clicked button.
    truncated_directories = selected_directory == 1 ? joinpath(first(path_directories)) : joinpath(path_directories[1:selected_directory]...)
    path₂ = Path(truncated_directories, get_filename(path))
    set_path!(model, path₂, UnconfirmedStatus())
end


function facilitate_directory_file_selection!(model::FileDialogModel)
    # Make a list of files and directories that are visibile from the current directory.
    CImGui.NewLine()
    CImGui.BeginChild("Directory and File Listing", CImGui.ImVec2(CImGui.GetWindowWidth() * 0.98, -CImGui.GetWindowHeight() * 0.2))
        CImGui.Columns(1)
        handle_directory_selection!(model)
        handle_file_selection!(model)
    CImGui.EndChild()
end

function handle_directory_selection!(model::FileDialogModel)
    path = get_path(model, UnconfirmedStatus())
    current_directory = get_directory(path)
    visible_directories = filter(p->is_readable_dir(joinpath(current_directory, p)), readdir(current_directory))
    for (n, foldername) in enumerate(visible_directories)
        # When the user clicks on a directory then change directory by appending the selected directory to the current path.
        if CImGui.Selectable("[Dir] " * "$foldername")
            selected_directory = joinpath(current_directory, foldername)
            path₂ = Path(selected_directory, "")
            set_path!(model, path₂, UnconfirmedStatus())
        end
    end
end

function handle_file_selection!(model::FileDialogModel)
    path = get_path(model, UnconfirmedStatus())
    current_directory = get_directory(path)
    visible_files = filter(p->is_queryable_file(joinpath(current_directory, p)), readdir(current_directory))
    selected_file = Cint(0)
    for (n, filename) in enumerate(visible_files)
        if CImGui.Selectable("[File] " * "$filename")
            path₂ = Path(current_directory, filename)
            set_path!(model, path₂, UnconfirmedStatus())
        end
    end
    handle_keyboard!(model)
end

function handle_keyboard!(model::FileDialogModel)
    CImGui.Text("File Name:")
    CImGui.SameLine()
    path = get_path(model, UnconfirmedStatus())
    current_directory = get_directory(path)
    filename₀ = get_filename(path)
    filename₁ = filename₀*"\0"^(1)
    # Allow up to 255 characters for the filename.
    pad_null = max(0, 255 - length(filename₁) + 1)
    buffer = filename₁*"\0"^(pad_null)
    CImGui.InputText("",buffer, length(buffer))
    filename₂ = extract_string(buffer)
    path₂ = Path(current_directory, filename₂)
    set_path!(model, path₂, UnconfirmedStatus())
end


function handle_cancellation_confirmation!(control::FileDialogControl, model::FileDialogModel, action::String, operation::AbstractOperation)
    CImGui.Button("Cancel") && disable!(control)
    CImGui.SameLine()
    CImGui.Button(action) && (handle_confirmation!(control, model, operation))
end

function handle_confirmation!(control::FileDialogControl, model::FileDialogModel, operation::AbstractOperation)
    path = get_path(model, UnconfirmedStatus())
    directory = get_directory(path)
    filename = get_filename(path)
    path_to_file = joinpath(directory, filename)
    if is_queryable_file(path_to_file)
        path₂ = Path(directory, filename)
        set_path!(model, path₂, ConfirmedStatus())
        enable!(operation)
        disable!(control)
    else
        CImGui.OpenPopup("Does the file exist?")
    end
end


function handle_confirmation!(control::FileDialogControl, model::FileDialogModel, operation::AbstractExporter)
    path = get_path(model, UnconfirmedStatus())
    directory = get_directory(path)
    filename = get_filename(path)
    path_to_file = joinpath(directory, filename)
    path₂ = Path(directory, filename)
    set_path!(model, path₂, ConfirmedStatus())
    enable!(operation)
    disable!(control)
end

function handle_file_error_messaging()
    if CImGui.BeginPopupModal("Does the file exist?", C_NULL, CImGui.ImGuiWindowFlags_AlwaysAutoResize)
        CImGui.Text("Unable to access the specified file.\nPlease verify that: \n   (1) the file exists; \n   (2) you have permission to access the file.\n\n")
        CImGui.Separator()
        CImGui.Button("OK", (120, 0)) && CImGui.CloseCurrentPopup()
        CImGui.SetItemDefaultFocus()
        CImGui.EndPopup()
    end
end

# The isdir function might not have permissions to query certan folders and
# will thus throw an ERROR: "IOError: stat: permission denied (EACCES)"
function is_readable_dir(path)
    flag = false
    try
        flag = isdir(path)
    catch x
        flag = false
    end
    return flag
end

# The isfile function might not have permissions to query certan files and
# will thus throw an ERROR: "IOError: stat: permission denied (EACCES)"
function is_queryable_file(path)
    flag = false
    try
        flag = isfile(path)
    catch x
        flag = false
    end
    return flag
end

function is_readable_file(path)
    if is_queryable_file(path)
        return (uperm(path) & 0x04 > 0) ? true :  false
    else
        return false
    end
end

function is_writeable_file(path)
    if is_queryable_file(path)
        return (uperm(path) & 0x02 > 0) ?  true :  false
    else
        return false
    end
end
