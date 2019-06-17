struct ImportContext{T₁ <: AbstractDialogControl,   T₂ <: AbstractDialogModel,  T₃ <: AbstractDisplayProperties, T₄ <: Union{AbstractImporter}} <: AbstractContext
    control::T₁
    model::T₂
    display_properties::T₃
    action::T₄
end

function (context::ImportContext)()
        control = context.control
        model = context.model
        display_properties = context.display_properties
        action = context.action
        isenabled(control) ? control(model, display_properties, action) : nothing
        data = isenabled(action) ? action(get_path(model, ConfirmedStatus())) : nothing
end

function isrunning(context::ImportContext)
        isenabled(context.control) || isenabled(context.action)
end

function enable!(context::ImportContext)
    enable!(context.control)
end
