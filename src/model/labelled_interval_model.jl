struct IntervalLabels <: AbstractData end

Base.@kwdef mutable struct LabelledInterval <: AbstractModel
    label::String = ""
    nested_interval::NestedInterval
end

Base.@kwdef mutable struct LabelledIntervals{T₁ <: Dict{String, LabelledInterval}}  <: AbstractModel
    description::String = ""
    labelled_intervals::T₁
end

function get_description(lis::LabelledIntervals)
    lis.description
end

function set_description!(lis::LabelledIntervals, description::String)
    lis.description = description
end

function get_labelled_intervals(lis::LabelledIntervals)
    lis.labelled_intervals
end

function set_labelled_intervals!(lis::LabelledIntervals, labelled_intervals::Dict{String, LabelledInterval})
    lis.labelled_intervals = labelled_intervals
end

function get_label(li::LabelledInterval)
    li.label
end

function set_label!(li::LabelledInterval, label)
    li.label = label
end

function get_nested_interval(li::LabelledInterval)
    li.nested_interval
end

function set_nested_interval!(li::LabelledInterval, nested_interval)
    li.nested_interval = nested_interval
end
