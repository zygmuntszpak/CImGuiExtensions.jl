
Base.@kwdef mutable struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::ImVec2 = ImVec2(0,0)
    width::Cfloat = Cfloat(320)
    height::Cfloat = Cfloat(200)
end

function get_caption(property::FileDialogDisplayProperties)
    property.caption
end

function get_action(property::FileDialogDisplayProperties)
    property.action
end

function get_position(property::FileDialogDisplayProperties)
    property.position
end

function get_width(property::FileDialogDisplayProperties)
    property.width
end

function get_height(property::FileDialogDisplayProperties)
    property.height
end

function set_caption!(property::FileDialogDisplayProperties, caption::String)
    property.caption = caption
end

function set_action!(property::FileDialogDisplayProperties, action::String)
    property.action = action
end

function set_position!(property::FileDialogDisplayProperties, position::ImVec2)
    property.position = position
end

function set_width!(property::FileDialogDisplayProperties, width::Cfloat)
    property.width = width
end

function set_height!(property::FileDialogDisplayProperties, height::Cfloat)
    property.height = height
end
