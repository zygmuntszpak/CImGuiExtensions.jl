
Base.@kwdef mutable struct FileDialogModel <: AbstractDialogModel
    confirmed_path::Path = Path(pwd(), "")
    unconfirmed_path::Path = Path(pwd(), "")
end


function get_path(model::FileDialogModel, status::ConfirmedStatus)
    model.confirmed_path
end

function get_path(model::FileDialogModel, status::UnconfirmedStatus)
    model.unconfirmed_path
end

function set_path!(model::FileDialogModel, path::Path, status::ConfirmedStatus)
    model.confirmed_path = path
end

function set_path!(model::FileDialogModel, path::Path, status::UnconfirmedStatus)
    model.unconfirmed_path = path
end
