
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

    #CImGui.Begin("EDA",C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus)
    isenabled(plot_control) ? plot_control(plot_model₂, plot_display_properties) : nothing
    CImGui.Dummy(ImVec2(0, 20))
    isenabled(interval_control) ? interval_control(interval_model, interval_display_properties) : nothing
    #CImGui.End()
end
