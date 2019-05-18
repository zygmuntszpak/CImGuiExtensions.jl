import Base.copy

Base.@kwdef mutable struct NestedInterval{T₁ <: AbstractRange} <: AbstractModel
    start::Float64
    stop::Float64
    interval::T₁
end



Base.@kwdef struct NestedIntervalDisplayProperties{T₁ <: PlotContext, T₂ <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::String
    col::ImVec4 = ImVec4(0, 0, 0, 1)
    createwindow::Bool = true
    layout::RectangularLayout
    plotcontext::T₁
    padding::T₂ = (0, 0, 0 ,0)
end

function copy(ni::NestedInterval)
    NestedInterval(get_start(ni), get_stop(ni), get_interval(ni))
end

function get_id(p::NestedIntervalDisplayProperties)
    p.id
end

function get_caption(p::NestedIntervalDisplayProperties)
    p.caption
end

function get_col(p::NestedIntervalDisplayProperties)
    p.col
end

function is_new_window(p::NestedIntervalDisplayProperties)
    p.createwindow
end

function get_layout(p::NestedIntervalDisplayProperties)
    p.layout
end

function get_padding(p::NestedIntervalDisplayProperties)
    p.padding
end

function get_plotcontext(p::NestedIntervalDisplayProperties)
   p.plotcontext
end

function get_start(ni::NestedInterval)
    ni.start
end

function set_start!(ni::NestedInterval, val::Number)
    ni.start = val > first(ni.interval) ? val : first(ni.interval)
end

function get_stop(ni::NestedInterval)
    ni.stop
end

function set_stop!(ni::NestedInterval, val::Number)
    ni.stop = val < last(ni.interval) ? val : last(ni.interval)
end

function get_interval(ni::NestedInterval)
    ni.interval
end

mutable struct NestedIntervalControl <: AbstractControl
    isenabled::Bool
end


struct NestedIntervalContext{T₁ <: AbstractControl,   T₂ <: AbstractModel,  T₃ <: AbstractDisplayProperties} <: AbstractPlotContext
    control::T₁
    model::T₂
    display_properties::T₃
end

function (context::NestedIntervalContext{<: NestedIntervalControl,   <: NestedInterval,  <: NestedIntervalDisplayProperties})()
        control = context.control
        model = context.model
        display_properties = context.display_properties
        id = get_id(display_properties)
        caption = get_caption(display_properties)
        is_new_window(display_properties) ? CImGui.Begin(caption*id,C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus) : nothing
        isenabled(control) ? control(model, display_properties) : nothing
        is_new_window(display_properties) ? CImGui.End() : nothing
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
      #CImGui.Text(@sprintf("Application average %.3f ms/frame (%.1f FPS)", 1000 / CImGui.GetIO().Framerate, CImGui.GetIO().Framerate))
      #CImGui.Text(@sprintf("Start: %.3f  / Stop: %.3f", get_start(model), get_stop(model)))
    end
    CImGui.Unindent(padding[2])
    CImGui.SetCursorScreenPos(pos.x, pos.y)
    #CImGui.AddRectFilled(draw_list, ImVec2(pos.x, pos.y), ImVec2(pos.x + width,  pos.y + height), Base.convert(ImU32, col));
    # The plotcontext allows us to plot data that appears underneath the nested interval control.
    plotcontext = get_plotcontext(properties)
    plotcontext()
    CImGui.AddRectFilled(draw_list, ImVec2(x₀, pos.y + 5), ImVec2(x₁,  pos.y + 5 + height), Base.convert(ImU32, ImVec4(0.0, 0, 0.99, 0.1)));
end
