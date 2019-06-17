Base.@kwdef mutable struct RectangularLayout <: AbstractLayout
    pos::ImVec2
    width::Cfloat
    height::Cfloat
end

function get_pos(l::RectangularLayout)
    l.pos
end

function set_pos!(l::RectangularLayout, pos::ImVec2)
    l.pos = pos
end

function get_width(l::RectangularLayout)
    l.width
end

function set_width!(l::RectangularLayout, width::Cfloat)
    l.width = width
end

function get_height(l::RectangularLayout)
    l.height
end

function set_height!(l::RectangularLayout, height::Cfloat)
    l.height = height
end
