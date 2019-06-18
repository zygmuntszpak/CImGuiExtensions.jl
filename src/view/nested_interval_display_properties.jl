Base.@kwdef struct NestedIntervalDisplayProperties{T₁ <: AbstractContext, T₂ <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::String
    col::ImVec4 = ImVec4(0, 0, 0, 1)
    createwindow::Bool = true
    layout::RectangularLayout
    plotcontext::T₁
    padding::T₂ = (0, 0, 0 ,0)
end

function get_id(p::NestedIntervalDisplayProperties)
    p.id
end

function set_id!(p::NestedIntervalDisplayProperties, id::String)
    p.id = id
end

function get_caption(p::NestedIntervalDisplayProperties)
    p.caption
end

function set_caption!(p::NestedIntervalDisplayProperties, caption::String)
    p.caption = caption
end

function get_col(p::NestedIntervalDisplayProperties)
    p.col
end

function set_col!(p::NestedIntervalDisplayProperties, col::ImVec4)
    p.col = col
end

function is_new_window(p::NestedIntervalDisplayProperties)
    p.createwindow
end

function get_layout(p::NestedIntervalDisplayProperties)
    p.layout
end

function set_layout!(p::NestedIntervalDisplayProperties, layout::RectangularLayout)
    p.layout = layout
end

function get_padding(p::NestedIntervalDisplayProperties)
    p.padding
end

function set_padding!(p::NestedIntervalDisplayProperties, padding::NTuple)
    p.padding = padding
end

function get_plotcontext(p::NestedIntervalDisplayProperties)
   p.plotcontext
end

function set_plotcontext!(p::NestedIntervalDisplayProperties, plotcontext::AbstractContext)
   p.plotcontext = plotcontext
end
