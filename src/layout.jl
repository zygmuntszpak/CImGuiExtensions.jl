Base.@kwdef  struct RectangularLayout <: AbstractLayout
    pos::ImVec2
    width::Cfloat
    height::Cfloat
end

function get_pos(l::RectangularLayout)
    l.pos
end

function get_width(l::RectangularLayout)
    l.width
end

function get_height(l::RectangularLayout)
    l.height
end
