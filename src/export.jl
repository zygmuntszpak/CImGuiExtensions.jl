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

function (store::CSVExporter{<:AbstractSchema})(path::Path, li::LabelledIntervals)
    # Convert labelled intervals to a dataframe.
    labelled_intervals = get_labelled_intervals(li)
    df = DataFrame(label = String[], start = Int64[], stop = Int64[], first = Float64[], step = Float64[], last  = Float64[])
    for (key, labelled_interval) in pairs(labelled_intervals)
        nested_interval = labelled_interval.nested_interval
        start = get_start(nested_interval)
        stop = get_stop(nested_interval)
        interval = get_interval(nested_interval)
        push!(df, [key start stop first(interval) step(interval) last(interval)])
    end
    Base.display(df)
    store(path, df)
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

function (context::ExportContext)(data::AbstractModel...)
        control = context.control
        model = context.model
        display_properties = context.display_properties
        action = context.action
        isenabled(control) ? control(model, display_properties, action) : nothing
        isenabled(action) ? action(get_path(model, ConfirmedStatus()), data...) : nothing
end

function isrunning(context::ExportContext)
        isenabled(context.control) || isenabled(context.action)
end

function enable!(context::ExportContext)
    enable!(context.control)
end
