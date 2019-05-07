Base.@kwdef struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::ImVec2 = ImVec2(0,0)
    width::Cfloat = Cfloat(320)
    heigh::Cfloat = Cfloat(200)
end

# Todo add margin
Base.@kwdef struct Tickmark{T <: Function}
    isenabled::Bool = true
    len::Cfloat = Cfloat(10)
    thickness::Cfloat = Cfloat(1)
    spacing::Cfloat = Cfloat(60)
    interpret::T = identity
end

Base.@kwdef struct PlotlinesDisplayProperties{T <: NTuple} <: AbstractDisplayProperties
    id::String
    caption::String
    col::ImVec4 = ImVec4(0,0, 0, 1)
    layout::RectangularLayout
    xtick::Tickmark = Tickmark()
    ytick::Tickmark = Tickmark()
    padding::T = (0, 0, 0 ,0)
end

# function set_caption!(p::PlotlinesDisplayProperties, caption::String)
#     p.caption = caption
# end

function get_spacing(tick::Tickmark)
    tick.spacing
end

function get_length(tick::Tickmark)
    tick.len
end

function get_interpreter(tick::Tickmark)
    tick.interpret
end

function isenabled(tick::Tickmark)
    tick.isenabled
end

function get_thickness(tick::Tickmark)
    tick.thickness
end

function get_id(p::PlotlinesDisplayProperties)
    p.id
end

function get_caption(p::PlotlinesDisplayProperties)
    p.caption
end

function get_col(p::PlotlinesDisplayProperties)
    p.col
end

function get_layout(p::PlotlinesDisplayProperties)
    p.layout
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
