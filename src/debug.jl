using CImGuiExtensions
using CImGui: ImVec2


struct CSVImporter <: AbstractImporter
    isenabled::Bool
end

control = FileDialogController(true)
model = FileDialogModel(Path(pwd(),"hello"), Path(pwd(),"hello"))
properties = FileDialogDisplayProperties("Open File", "Open", ImVec2(0,0), 100, 100)
load = CSVImporter(true)

control(model, properties, load)
