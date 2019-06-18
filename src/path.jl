Base.@kwdef mutable struct Path
    directory::String = ""
    filename::String = ""
end

function get_directory(p::Path)
    p.directory
end

function get_filename(p::Path)
    p.filename
end

function set_directory!(p::Path, directory::String)
    p.directory = directory
end

function set_filename!(p::Path, filename::String)
    p.filename = filename
end
