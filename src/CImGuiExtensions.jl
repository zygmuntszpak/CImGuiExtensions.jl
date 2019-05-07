module CImGuiExtensions

using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using CImGui: ImVec2, ImVec4, IM_COL32, ImU32
using CSV
using DataFrames

include("abstract_types.jl")
include("status.jl")
include("path.jl")
include("layout.jl")

# Project specific types which specify the vendor, product and type of
# data that you want to import. These types can be used to construct a schema
# for a particular file so that the import function can verify that the
# file structure conforms to expectations.
struct Empatica <: AbstractVendor end
struct E4 <: AbstractProduct end
struct SkinConductance <: AbstractData end
struct Tags <: AbstractData end
struct IntervalLabels <: AbstractData end

include("displayproperties.jl")
include("schemas.jl")
include("image_importer.jl")
include("filedialog.jl")
include("control.jl")
include("modelviewcontrol.jl")
include("nestedinterval.jl")
include("plotlines.jl")
include("import.jl")


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
       NestedIntervalDisplayProperties,
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
       AbstractLayout,
       RectangularLayout,
       NestedIntervalControl,
       PlotlinesControl,
       PlotlinesModel,
       PlotlinesDisplayProperties,
       AbstractContext,
       AbstractPlotContext,
       ImportContext,
       PlotContext,
       NestedInterval,
       Tickmark,
       isenabled,
       enable!,
       disable!,
       isrunning,
       Empatica,
       E4,
       SkinConductance,
       Tags,
       IntervalLabels

end # module

       # get_action,
       # get_model,
       # get_start,
       # get_stop,
       # get_interval,
       # get_width,
       # get_height,
       # get_pos,
       # get_length,
       # get_caption,
       # get_col,
       # get_padding,
       # get_layout,
       # get_directory,
       # get_filename,
       # get_path,
