
struct TruncatedPlotContext{T₁ <: AbstractControl, T₂ <: PlotContext,   T₃ <: NestedIntervalContext} <: AbstractPlotContext
    control::T₁
    plot_context::T₂
    interval_context::T₃
end


function (context::TruncatedPlotContext{<: PlotlinesControl, <:  PlotContext,   <: NestedIntervalContext})()
        control = context.control
        plot_context = context.plot_context
        interval_context = context.interval_context
        #CImGui.Begin("Main",C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus)
        isenabled(control) ? control(plot_context, interval_context) : nothing
        #CImGui.End()
end
