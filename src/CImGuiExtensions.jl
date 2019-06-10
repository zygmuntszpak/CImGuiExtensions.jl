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
include("displayproperties.jl")
include("schemas.jl")
include("image_importer.jl")
include("filedialog.jl")
include("control.jl")
include("plotlines.jl")
include("nestedinterval.jl")
include("labelintervals.jl")
include("truncatedplot.jl")
include("import.jl")
include("export.jl")

        # Abstract types
export  AbstractModel,
        AbstractDialogModel,
        AbstractStatus,
        AbstractDisplayProperties,
        AbstractControl,
        AbstractOperation,
        AbstractImporter,
        AbstractExporter,
        AbstractVendor,
        AbstractProduct,
        AbstractDialogControl,
        AbstractData,
        AbstractLayout,
        AbstractContext,
        AbstractPlotContext,
        AbstractSchema,
        AbstractModelViewControl,
        # Concrete types
        Path,
        FileDialogModel,
        EnabledStatus,
        DisabledStatus,
        ConfirmedStatus,
        UnconfirmedStatus,
        FileDialogDisplayProperties,
        NestedIntervalDisplayProperties,
        FileDialogControl,
        GenericVendor,
        GenericProduct,
        CSVSchema,
        CSVImporter,
        ImageImporter,
        CSVExporter,
        RectangularLayout,
        NestedIntervalControl,
        NestedIntervalContext,
        PlotlinesControl,
        PlotlinesModel,
        PlotlinesDisplayProperties,
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
        # Functions
        isenabled,
        enable!,
        disable!,
        isrunning,
        get_labelled_intervals,
        load_dataframe,
        get_start,
        get_stop,
        set_start!,
        set_stop!,
        get_width,
        get_height,
        get_padding,
        get_data,
        get_layout,
        stretch_linearly
end # module
