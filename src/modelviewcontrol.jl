struct ModelViewControl{T₁ <: AbstractControl,   T₂ <: AbstractModel,  T₃ <: AbstractDisplayProperties, T₄ <: Union{AbstractOperation, AbstractModel}} <: AbstractModelViewControl
    control::T₁
    model::T₂
    display_properties::T₃
    action::T₄
end


function (mvc::ModelViewControl)()
        control = mvc.control
        model = mvc.model
        display_properties = mvc.display_properties
        action = mvc.action
        isenabled(control) ? control(model, display_properties, action) : nothing
end

function enable!(mvc::ModelViewControl)
    enable!(mvc.control)
end

function isenabled(mvc::ModelViewControl)
    isenabled(mvc.control)
end

function disable!(mvc::ModelViewControl)
    disable!(mvc.control)
end

function get_action(mvc::ModelViewControl)
    mvc.action
end

function get_model(mvc::ModelViewControl)
    mvc.model
end
