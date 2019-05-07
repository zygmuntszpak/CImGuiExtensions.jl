
mutable struct CSVImporter{T <: AbstractSchema} <: AbstractImporter
    isenabled::Bool
    schema::T
end

function isenabled(importer::CSVImporter)
    return importer.isenabled
end

function enable!(importer::CSVImporter)
    importer.isenabled = true
end

function disable!(importer::CSVImporter)
    importer.isenabled  = false
end

function (load::CSVImporter{AbstractSchema})(path::Path)
    @show "Inside generic CSV importer..."
end
