module CImGuiExtensions

using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using CImGui: ImVec2, ImVec4, IM_COL32, ImU32

include("abstract_types.jl")

# Project specific types which specify the vendor, product and type of
# data that you want to import. These types can be used to construct a schema
# for a particular file so that the import function can verify that the
# file structure conforms to expectations.
struct Empatica <: AbstractVendor end
struct E4 <: AbstractProduct end
struct SkinConductance <: AbstractData end
struct Tags <: AbstractData end
struct IntervalLabels <: AbstractData end


include("schemas.jl")
include("filedialog.jl")
include("modelviewcontrol.jl")

export Path,
       AbstractModel,
       AbstractDialogModel,
       FileDialogModel,
       AbstractStatus,
       EnabledStatus,
       DisabledStatus,
       ConfirmedStatus,
       UnconfirmedStatus,
       AbstractDisplayProperties,
       FileDialogDisplayProperties,
       AbstractDialogControl,
       FileDialogControl,
       AbstractControl,
       AbstractOperation,
       AbstractImporter,
       AbstractVendor,
       AbstractProduct,
       AbstractData,
       AbstractSchema,
       CSVSchema,
       AbstractModelViewControl,
       ModelViewControl,
       CSVImporter,
       ImageImporter,
       get_directory,
       get_filename,
       get_path,
       isenabled,
       enable!,
       disable!,
       get_action,
       get_model
       # Empatica,
       # E4,
       # SkinConductance,
       # Tags,
       # IntervalLabels

end # module
