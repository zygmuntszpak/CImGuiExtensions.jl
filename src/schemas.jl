# Base.@kwdef struct CSVSchema{T₁ <: AbstractVendor,  T₂ <: AbstractProduct, T₃ <: AbstractData} <: AbstractSchema
#     vendor::T₁ = GenericVendor()
#     product::T₂ = GenericProduct()
#     data::T₃ =
# end

struct CSVSchema{T₁ <: AbstractVendor,  T₂ <: AbstractProduct, T₃ <: AbstractData} <: AbstractSchema
    vendor::T₁
    product::T₂
    data::T₃
end
