import Base.copy

Base.@kwdef mutable struct NestedInterval{T₁ <: AbstractRange} <: AbstractModel
    start::Float64
    stop::Float64
    interval::T₁
end

function get_start(ni::NestedInterval)
    ni.start
end

function set_start!(ni::NestedInterval, val::Number)
    ni.start = val > first(ni.interval) ? val : first(ni.interval)
end

function get_stop(ni::NestedInterval)
    ni.stop
end

function set_stop!(ni::NestedInterval, val::Number)
    ni.stop = val < last(ni.interval) ? val : last(ni.interval)
end

function get_interval(ni::NestedInterval)
    ni.interval
end

function set_interval!(ni::NestedInterval, interval::AbstractRange)
    ni.interval = interval
end

function copy(ni::NestedInterval)
    NestedInterval(get_start(ni), get_stop(ni), get_interval(ni))
end
