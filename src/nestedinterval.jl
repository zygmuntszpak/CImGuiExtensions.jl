mutable struct NestedInterval{T₁ <: Number, T₂ <: Number, T₃ <: AbstractRange}
    start::T₁
    stop::T₂
    interval::T₃
end

function get_start(ni::NestedInterval)
    ni.start
end

function get_stop(ni::NestedInterval)
    ni.stop
end

function get_interval(ni::NestedInterval)
    ni.interval
end

mutable struct NestedIntervalControl <: AbstractControl
    isenabled::Bool
end
