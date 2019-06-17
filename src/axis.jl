Base.@kwdef mutable struct Axis
    isenabled::Bool = true
    thickness::Cfloat = Cfloat(1)
end

function isenabled(axis::Axis)
    axis.isenabled
end

function enable!(axis::Axis)
    axis.isenabled = true
end

function disable!(axis::Axis)
    axis.isenabled = false
end

function get_thickness(axis::Axis)
    axis.thickness
end

function set_thickness!(axis::Axis, thickness::Cfloat)
    axis.thickness = thickness
end
