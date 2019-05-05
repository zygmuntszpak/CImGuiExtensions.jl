mutable struct ImageImporter <: AbstractImporter
    isenabled::Bool
end

function isenabled(importer::ImageImporter)
    return importer.isenabled
end

function enable!(importer::ImageImporter)
    importer.isenabled = true
end

function disable!(importer::ImageImporter)
    importer.isenabled  = false
end
