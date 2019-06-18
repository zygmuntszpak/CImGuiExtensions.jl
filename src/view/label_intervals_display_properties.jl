Base.@kwdef mutable struct LabelIntervalDisplayProperties{T₁ <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::String
    col::ImVec4 = ImVec4(0.9, 0, 0, 0.3)
    textcol::ImVec4 = ImVec4(0.4, 0.4, 0.4, 1)
    createwindow::Bool = true
    layout::RectangularLayout
    padding::T₁ = (0, 0, 0 ,0)
end

function get_id(p::LabelIntervalDisplayProperties)
    p.id
end

function set_id!(p::LabelIntervalDisplayProperties, id::String)
    p.id = id
end

function get_caption(p::LabelIntervalDisplayProperties)
    p.caption
end

function set_caption!(p::LabelIntervalDisplayProperties, caption::String)
    p.caption = caption
end

function get_col(p::LabelIntervalDisplayProperties)
    p.col
end

function set_col!(p::LabelIntervalDisplayProperties, col::ImVec4)
    p.col = col
end

function get_textcol(p::LabelIntervalDisplayProperties)
    p.textcol
end

function set_textcol!(p::LabelIntervalDisplayProperties, textcol::ImVec4)
    p.textcol = textcol
end

function is_new_window(p::LabelIntervalDisplayProperties)
    p.createwindow
end

function get_layout(p::LabelIntervalDisplayProperties)
    p.layout
end

function set_layout!(p::LabelIntervalDisplayProperties, layout::RectangularLayout)
    p.layout = layout
end

function get_padding(p::LabelIntervalDisplayProperties)
    p.padding
end

function set_padding!(p::LabelIntervalDisplayProperties, padding::NTuple)
    p.padding = padding
end
