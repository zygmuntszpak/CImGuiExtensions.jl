
mutable struct CSVImporter <: AbstractImporter
    isenabled::Bool
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

function (load::CSVImporter)(path::Path)
    @show "Inside importer..."
end
