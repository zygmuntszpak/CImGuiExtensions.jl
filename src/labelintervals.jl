struct IntervalLabels <: AbstractData end

Base.@kwdef mutable struct LabelledInterval <: AbstractModel
    label::String = ""
    nested_interval::NestedInterval
end

Base.@kwdef mutable struct LabelledIntervals{T₁ <: Dict{String, LabelledInterval}}  <: AbstractModel
    description::String = ""
    labelled_intervals::T₁
end

function get_description(lis::LabelledIntervals)
    lis.description
end

function get_labelled_intervals(lis::LabelledIntervals)
    lis.labelled_intervals
end

function get_label(li::LabelledInterval)
    li.label
end

function set_label!(li::LabelledInterval, label)
    li.label = label
end

function get_nested_interval(li::LabelledInterval)
    li.nested_interval
end

function set_nested_interval!(li::LabelledInterval, nested_interval)
    li.nested_interval = nested_interval
end


Base.@kwdef struct LabelIntervalDisplayProperties{T₁ <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::String
    col::ImVec4 = ImVec4(0.9, 0, 0, 0.3)
    textcol::ImVec4 = ImVec4(0.4, 0.4, 0.4, 1)
    createwindow::Bool = true
    layout::RectangularLayout
    padding::T₁ = (0, 0, 0 ,0)
end


function get_id(p::LabelIntervalDisplayProperties)
    p.id
end

function get_caption(p::LabelIntervalDisplayProperties)
    p.caption
end

function get_col(p::LabelIntervalDisplayProperties)
    p.col
end

function get_textcol(p::LabelIntervalDisplayProperties)
    p.textcol
end

function is_new_window(p::LabelIntervalDisplayProperties)
    p.createwindow
end

function get_layout(p::LabelIntervalDisplayProperties)
    p.layout
end

function get_padding(p::LabelIntervalDisplayProperties)
    p.padding
end

function get_plotcontext(p::LabelIntervalDisplayProperties)
   p.plotcontext
end


mutable struct LabelIntervalControl <: AbstractControl
    isenabled::Bool
    nested_interval::NestedInterval
    buffer::String
end

struct LabelIntervalContext{T₁ <: AbstractControl,   T₂ <: AbstractModel,  T₃ <: AbstractDisplayProperties, T₄ <: AbstractPlotContext} <: AbstractContext
    control::T₁
    model::T₂
    display_properties::T₃
    plot_context::T₄
end

function (context::LabelIntervalContext{<: LabelIntervalControl,   <: LabelledIntervals,  <:LabelIntervalDisplayProperties, <: PlotContext})()
        control = context.control
        model = context.model
        display_properties = context.display_properties
        plot_context = context.plot_context
        # We need to plot the data on top of which we shall place the event markers.
        # plot_context = context.plot_context
        # plot_model = plot_context.model
        # plot_display_properties = plot_context.display_properties
        # plot_control = plot_context.control


        #description = get_description(display_properties)
        id = get_id(display_properties)
        caption = get_caption(display_properties)
        is_new_window(display_properties) ? CImGui.Begin(caption*id,C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus) : nothing
        isenabled(control) ? control(model, display_properties, plot_context) : nothing
        #isenabled(plot_control) ? control(plot_model, plot_display_properties) : nothing
        #plot_control(plot_model, plot_display_properties)
        is_new_window(display_properties) ? CImGui.End() : nothing
end

function (control::LabelIntervalControl)(model::LabelledIntervals, properties::LabelIntervalDisplayProperties, plot_context::PlotContext)
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
        CImGui.IsItemHovered() && CImGui.SetTooltip(string("Hello"))
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
    #@show control.buffer
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
