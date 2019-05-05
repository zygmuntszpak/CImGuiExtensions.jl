mutable struct FileDialogController <: AbstractDialogController
    isenabled::Bool
end

function isenabled(controller::FileDialogController)
    return controller.isenabled
end

function enable!(controller::FileDialogController)
    controller.isenabled = true
end

function disable!(controller::FileDialogController)
    controller.isenabled  = false
end
