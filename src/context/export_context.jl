
struct ExportContext{T₁ <: AbstractDialogControl,   T₂ <: AbstractDialogModel,  T₃ <: AbstractDisplayProperties, T₄ <: Union{AbstractExporter}} <: AbstractContext
    control::T₁
    model::T₂
    display_properties::T₃
    action::T₄
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
