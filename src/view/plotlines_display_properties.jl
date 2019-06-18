Base.@kwdef mutable struct PlotlinesDisplayProperties{T₁ <: Function, T₂ <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::T₁
    col::ImVec4 = ImVec4(0, 0, 0, 1)
    createwindow::Bool = true
    layout::RectangularLayout
    yaxis::Axis = Axis()
    xaxis::Axis = Axis()
    xtick::Tickmark = Tickmark()
    ytick::Tickmark = Tickmark()
    padding::T₂ = (0, 0, 0 ,0)
end

function get_id(p::PlotlinesDisplayProperties)
    p.id
end

function get_captioner(p::PlotlinesDisplayProperties)
    p.caption
end

function get_col(p::PlotlinesDisplayProperties)
    p.col
end

function is_new_window(p::PlotlinesDisplayProperties)
    p.createwindow
end

function get_layout(p::PlotlinesDisplayProperties)
    p.layout
end

function get_xaxis(p::PlotlinesDisplayProperties)
    p.xaxis
end

function get_yaxis(p::PlotlinesDisplayProperties)
    p.yaxis
end

function get_xtick(p::PlotlinesDisplayProperties)
    p.xtick
end

function get_ytick(p::PlotlinesDisplayProperties)
    p.ytick
end

function get_padding(p::PlotlinesDisplayProperties)
    p.padding
end

function set_id!(p::PlotlinesDisplayProperties, id::String)
    p.id = id
end

#TODO change captioner to caption
function set_captioner!(p::PlotlinesDisplayProperties, caption::Function)
    p.caption = caption
end

function set_col!(p::PlotlinesDisplayProperties, col::ImVec4)
    p.col = col
end

function set_layout!(p::PlotlinesDisplayProperties, layout::RectangularLayout)
    p.layout = layout
end

function set_xtick!(p::PlotlinesDisplayProperties, xtick::Tickmark)
    p.xtick = xtick
end

function set_ytick!(p::PlotlinesDisplayProperties, ytick::Tickmark)
    p.ytick = ytick
end

function set_paddding!(p::PlotlinesDisplayProperties, padding::NTuple)
    p.padding = padding
end
