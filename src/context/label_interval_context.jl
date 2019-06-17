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
        id = get_id(display_properties)
        caption = get_caption(display_properties)
        is_new_window(display_properties) ? CImGui.Begin(caption*id,C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus) : nothing
        isenabled(control) ? control(model, display_properties, plot_context) : nothing
        is_new_window(display_properties) ? CImGui.End() : nothing
end
