struct PlotContext{T₁ <: AbstractControl,   T₂ <: AbstractModel,  T₃ <: AbstractDisplayProperties} <: AbstractPlotContext
    control::T₁
    model::T₂
    display_properties::T₃
end

function (context::PlotContext{<: PlotlinesControl,   <: PlotlinesModel,  <: PlotlinesDisplayProperties})()
        control = context.control
        model = context.model
        display_properties = context.display_properties
        id = get_id(display_properties)
        captioner = get_captioner(display_properties)
        caption = captioner(nothing)
        is_new_window(display_properties) ? CImGui.Begin(caption*id,C_NULL, CImGui.ImGuiWindowFlags_NoBringToFrontOnFocus) : nothing
        isenabled(control) ? control(model, display_properties) : nothing
        is_new_window(display_properties) ? CImGui.End() : nothing
end
