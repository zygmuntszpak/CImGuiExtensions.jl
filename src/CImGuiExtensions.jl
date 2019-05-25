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
using Printf

include("abstract_types.jl")
include("util.jl")
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
include("plotlines.jl")
include("nestedinterval.jl")
include("labelintervals.jl")
include("truncatedplot.jl")
include("import.jl")
include("export.jl")


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
       AbstractExporter,
       AbstractVendor,
       AbstractProduct,
       AbstractData,
       GenericVendor,
       GenericProduct,
       AbstractSchema,
       CSVSchema,
       AbstractModelViewControl,
       ModelViewControl,
       CSVImporter,
       ImageImporter,
       CSVExporter,
       AbstractLayout,
       RectangularLayout,
       NestedIntervalControl,
       NestedIntervalContext,
       PlotlinesControl,
       PlotlinesModel,
       PlotlinesDisplayProperties,
       AbstractContext,
       AbstractPlotContext,
       ImportContext,
       ExportContext,
       PlotContext,
       NestedInterval,
       Tickmark,
       Axis,
       TruncatedPlotContext,
       LabelledIntervals,
       LabelledInterval,
       LabelIntervalContext,
       LabelIntervalControl,
       LabelIntervalDisplayProperties,
       IntervalLabels,
       isenabled,
       enable!,
       disable!,
       isrunning,
       get_labelled_intervals,
       load_dataframe,
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
