mutable struct PlotlinesModel{T₁ <: AbstractVector} <: AbstractModel
    data::T₁
end

function get_data(model::PlotlinesModel)
    model.data
end

function set_data!(model::PlotlinesModel, data::AbstractVector)
    model.data = data
end
