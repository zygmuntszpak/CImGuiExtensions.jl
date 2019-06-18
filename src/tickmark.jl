# TODO add margin
Base.@kwdef mutable struct Tickmark{T <: Function}
    isenabled::Bool = true
    len::Cfloat = Cfloat(10)
    thickness::Cfloat = Cfloat(1)
    spacing::Cfloat = Cfloat(60)
    interpret::T = identity
end

function get_spacing(tick::Tickmark)
    tick.spacing
end

function get_length(tick::Tickmark)
    tick.len
end

function get_thickness(tick::Tickmark)
    tick.thickness
end

function get_interpreter(tick::Tickmark)
    tick.interpret
end

function isenabled(tick::Tickmark)
    tick.isenabled
end

function set_spacing!(tick::Tickmark, spacing::Cfloat)
    tick.spacing = spacing
end

function set_length!(tick::Tickmark, len::Cfloat)
    tick.len = len
end

function set_thickness!(tick::Tickmark, thickness::Cfloat)
    tick.thickness = thickness
end

function set_interpreter!(tick::Tickmark, interpret::Function)
    tick.interpret = interpret
end

function enabled!(tick::Tickmark)
    tick.isenabled = true
end

function disable!(tick::Tickmark)
    tick.isenabled = false
end
