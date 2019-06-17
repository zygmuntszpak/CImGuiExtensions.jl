mutable struct NestedIntervalControl <: AbstractControl
    isenabled::Bool
end

function (control::NestedIntervalControl)(model::NestedInterval, properties::NestedIntervalDisplayProperties)
    id = get_id(properties)
    caption = get_caption(properties)
    col = get_col(properties)
    rectangle = get_layout(properties)
    # pos = get_pos(rectangle) % TODO Remove this
    totalwidth = get_width(rectangle)
    totalheight = get_height(rectangle)
    padding = get_padding(properties)
    interval = get_interval(model)
    start = get_start(model)
    stop = get_stop(model)
    CImGui.Dummy(ImVec2(0, padding[1]))
    CImGui.Indent(padding[2])
    width = totalwidth - padding[2]
    height = totalheight
    draw_list = CImGui.GetWindowDrawList()
    pos = CImGui.GetCursorScreenPos()
    CImGui.InvisibleButton("###Invisible Nested Interval Button", ImVec2(width, height))
    x₀ = stretch_linearly(start, first(interval), last(interval), pos.x, pos.x + width)
    x₁ = stretch_linearly(stop, first(interval), last(interval), pos.x, pos.x + width)
    io = CImGui.GetIO()
    if CImGui.IsItemHovered()
       mousepos = io.MousePos
       # Relax threshold when dragging to make things smoother
       if (abs(x₀ - mousepos.x) <=  25)
           CImGui.SetMouseCursor(CImGui.ImGuiMouseCursor_ResizeEW)
           if CImGui.IsItemActive()
               i₀ = stretch_linearly(io.MousePos.x, pos.x, pos.x + width, first(interval), last(interval))
               # Round to the nearest multiple of the interval stepsize
               s = step(interval)
               i₀′ = div(i₀ + (s / 2), s) * s
               set_start!(model, i₀′)
           end
       elseif (abs(x₁ - mousepos.x) <= 25)
           CImGui.SetMouseCursor(CImGui.ImGuiMouseCursor_ResizeEW)
           if CImGui.IsItemActive()
               i₁ = stretch_linearly(io.MousePos.x, pos.x, pos.x + width, first(interval), last(interval))
               # Round to the nearest multiple of the interval stepsize
               s = step(interval)
               i₁′ = div(i₁ + (s / 2), s) * s
               set_stop!(model,  i₁′)
           end
       end
       # Make sure that start is always less than or equal to stop
       if get_start(model) > get_stop(model)
           x₀′ = get_start(model)
           set_start!(model, get_stop(model))
           set_stop!(model, x₀′)
       end
    end
    CImGui.Unindent(padding[2])
    CImGui.SetCursorScreenPos(pos.x, pos.y)
    # The plotcontext allows us to plot data that appears underneath the nested interval control.
    plotcontext = get_plotcontext(properties)
    plotcontext()
    CImGui.AddRectFilled(draw_list, ImVec2(x₀, pos.y + 5), ImVec2(x₁,  pos.y + 5 + height), Base.convert(ImU32, ImVec4(0.0, 0, 0.99, 0.1)));
end
