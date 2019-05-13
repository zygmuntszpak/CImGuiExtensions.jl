

struct TruncatedPlotContext{T₁ <: AbstractControl, T₂ <: PlotContext,   T₃ <: NestedIntervalContext} <: AbstractPlotContext
    control::T₁
    plot_context::T₂
    interval_context::T₃
end


function (context::TruncatedPlotContext{<: PlotlinesControl, <:  PlotContext,   <: NestedIntervalContext})()
        control = context.control
        plot_context = context.plot_context
        interval_context = context.interval_context
        CImGui.Begin("Main",C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus)
            isenabled(control) ? control(plot_context, interval_context) : nothing
        CImGui.End()
end

function (control::PlotlinesControl)(plot_context::PlotContext, interval_context::NestedIntervalContext)
    plot_control = plot_context.control
    plot_model = plot_context.model
    plot_display_properties = plot_context.display_properties

    interval_control = interval_context.control
    interval_model = interval_context.model
    interval_display_properties = interval_context.display_properties

    data = get_data(plot_model)
    i₀ = Int(get_start(interval_model))
    i₁ = Int(get_stop(interval_model))
    plot_model₂ = PlotlinesModel(data[i₀:i₁])

    CImGui.Begin("Main",C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus)
        #CImGui.BeginGroup()
        isenabled(plot_control) ? plot_control(plot_model₂, plot_display_properties) : nothing
        #CImGui.EndGroup()
        CImGui.Dummy(ImVec2(0, 20))
        isenabled(interval_control) ? interval_control(interval_model, interval_display_properties) : nothing
    CImGui.End()
end
