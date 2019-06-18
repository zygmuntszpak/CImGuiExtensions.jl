mutable struct LabelIntervalControl <: AbstractControl
    isenabled::Bool
    nested_interval::NestedInterval
    buffer::String
end

function (control::LabelIntervalControl)(model::LabelledIntervals, properties::LabelIntervalDisplayProperties, plot_context::AbstractContext)
    id = get_id(properties)
    caption = get_caption(properties)
    col = get_col(properties)
    textcol = get_textcol(properties)
    rectangle = get_layout(properties)
    totalwidth = get_width(rectangle)
    totalheight = get_height(rectangle)
    padding = get_padding(properties)
    CImGui.Dummy(ImVec2(0, padding[1]))
    width = totalwidth - padding[2]
    height = totalheight
    CImGui.Indent(padding[2])
    pos = CImGui.GetCursorScreenPos()
    #CImGui.InvisibleButton("###Events Overview Button", ImVec2(width, height))
    CImGui.Unindent(padding[2])
    CImGui.SetCursorScreenPos(pos.x, pos.y)
    # Plot the overview
    plot_context()

    draw_list = CImGui.GetWindowDrawList()
    yoffset = 3
    # Draw the labelled intervals
    for (key, labelled_interval) in pairs(get_labelled_intervals(model))
        # Map interval position to screen coordinates
        nested_interval = get_nested_interval(labelled_interval)
        interval = get_interval(nested_interval)
        start = get_start(nested_interval)
        stop =  get_stop(nested_interval)
        x₀ = stretch_linearly(start, first(interval), last(interval), pos.x, pos.x + width)
        x₁ = stretch_linearly(stop, first(interval), last(interval), pos.x, pos.x + width)
        # Shaded region
        CImGui.AddRectFilled(draw_list, ImVec2(x₀, pos.y + yoffset), ImVec2(x₁,  pos.y + height + yoffset), Base.convert(ImU32, col))
        # Text Label
        first_nul = findfirst(isequal('\0'), key)
        str = isnothing(first_nul) ? key : key[1:first_nul-1]
        CImGui.AddText(draw_list, ImVec2(x₀ + 5, pos.y + yoffset + 5), Base.convert(ImU32, textcol) , str)
        # Handle event selection
        CImGui.SetCursorScreenPos(x₀, pos.y)
        CImGui.InvisibleButton("###interval button $str", ImVec2(x₁ - x₀, height))
        # TODO Improve tooltip
        #CImGui.IsItemHovered() && CImGui.SetTooltip(string("Hello"))
        if CImGui.IsItemClicked()
            # Update the principal nested interval in accordance with the selection.
            set_start!(control.nested_interval, start)
            set_stop!(control.nested_interval, stop)
            # Update the text for the label in accordance with the selection.
            buffer = key*"\0"^(1)
            # Allow up to 64 characters for the label buffer.
            pad_null = max(0, 255 - length(buffer) + 1)
            control.buffer = buffer*"\0"^(pad_null)
        end
        CImGui.SameLine()
        CImGui.SetCursorScreenPos(pos.x, pos.y)
    end

    # Draw indicators for the currently selected interval
    current_nested_interval = control.nested_interval
    interval = get_interval(current_nested_interval)
    start = get_start(current_nested_interval)
    stop =  get_stop(current_nested_interval)
    x₀ = stretch_linearly(start, first(interval), last(interval), pos.x, pos.x + width)
    x₁ = stretch_linearly(stop, first(interval), last(interval), pos.x, pos.x + width)

    CImGui.AddLine(draw_list, ImVec2(x₀, pos.y + yoffset), ImVec2(x₀ , pos.y + height + yoffset), Base.convert(ImU32, ImVec4(0.0, 0.0, 0.0, 0.9)), Cfloat(2));
    CImGui.AddLine(draw_list, ImVec2(x₁, pos.y + yoffset), ImVec2(x₁ , pos.y + height + yoffset), Base.convert(ImU32, ImVec4(0.0, 0.0, 0.0, 0.9)), Cfloat(2));

    # Handle creation of new event labels
    CImGui.NewLine()
    CImGui.NewLine()
    CImGui.Indent(padding[2])
    CImGui.PushItemWidth(150)
    CImGui.InputText("###event description", control.buffer, length(control.buffer))
    CImGui.PopItemWidth()
    CImGui.SameLine()
    CImGui.Button("Create Interval Label") && add_label!(get_labelled_intervals(model), control.buffer, control.nested_interval)
    CImGui.SameLine()
    CImGui.Button("Remove Interval Label") && remove_label!(get_labelled_intervals(model), control.buffer)
    CImGui.Unindent(padding[2])
end

function add_label!(labelled_intervals::Dict{String, LabelledInterval}, label::String, ni::NestedInterval)
    key = extract_string(label)
    labelled_intervals[key] = LabelledInterval(key, copy(ni))
end

function remove_label!(labelled_intervals::Dict{String, LabelledInterval}, label::String)
    key = extract_string(label)
    if haskey(labelled_intervals, key)
        delete!(labelled_intervals, key)
    end
end
