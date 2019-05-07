function isenabled(controller::AbstractControl)
    return controller.isenabled
end

function enable!(controller::AbstractControl)
    controller.isenabled = true
end

function disable!(controller::AbstractControl)
    controller.isenabled  = false
end
