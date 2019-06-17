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
include("context/export_context.jl")
include("context/import_context.jl")

include("control/control.jl")

include("layout.jl")
include("axis.jl")
include("tickmark.jl")


include("view/plotlines_display_properties.jl")
include("model/plotlines_model.jl")
include("control/plotlines_control.jl")

include("view/file_dialog_display_properties.jl")
include("model/file_dialog_model.jl")
include("control/file_dialog_control.jl")

include("view/nested_interval_display_properties.jl")
include("model/nested_interval_model.jl")
include("control/nested_interval_control.jl")

include("view/label_intervals_display_properties.jl")
include("model/labelled_interval_model.jl")
include("control/label_interval_control.jl")

include("schemas.jl")

include("operation/csv_import.jl")
include("operation/csv_export.jl")
include("operation/labelled_intervals_import.jl")
include("operation/labelled_intervals_export.jl")

include("context/plotlines_context.jl")

include("context/nested_interval_context.jl")
include("context/label_interval_context.jl")

include("control/truncated_plot_control.jl")
include("context/truncated_plot_context.jl")



#include("displayproperties.jl")
# include("tickmark.jl")
# include("axis.jl")
# include("schemas.jl")
# include("image_importer.jl")
# include("filedialog.jl")
# include("control.jl")
# include("plotlines.jl")
# include("nestedinterval.jl")
# include("labelintervals.jl")
# include("truncatedplot.jl")
# include("import.jl")
# include("export.jl")

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
        get_path,
        set_path!,
        get_description,
        set_description!,
        get_labelled_intervals,
        set_labelled_intervals!,
        get_label,
        set_label!,
        get_nested_interval,
        set_nested_interval!,
        get_start,
        set_start!,
        get_stop,
        set_stop!,
        get_interval,
        set_interval!,
        copy,
        get_data,
        set_data!,
        isenabled,
        enable!,
        disable!,
        isrunning,
        load_dataframe,
        get_caption,
        set_caption!,
        get_action,
        set_action!,
        get_width,
        set_width!,
        get_height,
        set_height!,
        get_id,
        set_id!,
        get_caption,
        set_caption!,
        get_col,
        set_col!,
        get_textcol,
        set_textcol!,
        get_layout,
        set_layout!,
        get_padding,
        set_padding!,
        get_plotcontex,
        set_plotcontext!,
        get_xtick,
        set_xtick!,
        get_ytick,
        set_ytick!,
        get_yaxis,
        set_yaxis!,
        get_xaxis,
        set_xaxis!,
        get_thickness,
        set_thickness!,
        get_pos,
        set_pos!,
        get_directory,
        set_directory!,
        get_filename,
        set_filename!,
        get_interpreter,
        set_interpreter!,
        get_length,
        set_length!,
        get_spacing,
        set_spacing!,
        get_interpreter,
        set_interpreter!,
        get_captioner,
        set_captioner!,
        stretch_linearly
end # module
