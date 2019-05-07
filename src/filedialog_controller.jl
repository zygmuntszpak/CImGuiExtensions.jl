mutable struct FileDialogControl <: AbstractDialogControl
    isenabled::Bool
end

function isenabled(controller::FileDialogControl)
    return controller.isenabled
end

function enable!(controller::FileDialogControl)
    controller.isenabled = true
end

function disable!(controller::FileDialogControl)
    controller.isenabled  = false
end
