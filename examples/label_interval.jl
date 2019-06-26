using CImGui
using CImGui.CSyntax
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using CImGuiExtensions
using CImGui: ImVec2, ImVec4, IM_COL32, ImU32
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using DataFrames # For this example, don't forget to add this package.
using Printf



function create_labelled_interval_context(data::AbstractArray)
    padding = (8,8,0,0)
    # The plot context draws an overview of the data.
    model = PlotlinesModel(data)
    outline_layout = RectangularLayout(pos = ImVec2(0,0), width = Cfloat(800), height = Cfloat(80))
    display_properties = PlotlinesDisplayProperties(id = "###overview"; caption = x -> "", createwindow = false, layout = outline_layout, xaxis = Axis(false, Cfloat(1)), yaxis = Axis(false, Cfloat(1)), padding = padding)
    plot_outline_context = PlotContext(PlotlinesControl(true), model, display_properties)

    # The nested interval keeps track of which portion of the data the user wants to select.
    nested_interval = NestedInterval(start = Float64(1.0), stop = Float64(length(data)), interval = 1:length(data))

    # The label interval context allows the user to label and mark a selected interval.
    label_control = LabelIntervalControl(true, nested_interval, "\0"^64*"\0")
    label_display_properties = LabelIntervalDisplayProperties(id = "###event markers" ; caption = "Conditions", createwindow =  false, col = ImVec4(0.0, 0, 0.9, 0.1), textcol = ImVec4(1.0, 1.0, 0.2, 1), layout = outline_layout, padding = padding)
    dict = Dict{String, LabelledInterval}()
    labelled_intervals = LabelledIntervals("Conditions", dict)
    label_interval_context = LabelIntervalContext(label_control, labelled_intervals, label_display_properties, plot_outline_context)
    return label_interval_context
end

function label_interval_example()

    @static if Sys.isapple()
        # OpenGL 3.2 + GLSL 150
        glsl_version = 150
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
    else
        # OpenGL 3.0 + GLSL 130
        glsl_version = 130
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
        # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # 3.0+ only
    end

    # setup GLFW error callback
    error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"
    GLFW.SetErrorCallback(error_callback)

    # create window
    window = GLFW.CreateWindow(1280, 720, "Demo")
    @assert window != C_NULL
    GLFW.MakeContextCurrent(window)
    GLFW.SwapInterval(1)  # enable vsync

    # setup Dear ImGui context
    ctx = CImGui.CreateContext()

    # setup Dear ImGui style
    CImGui.StyleColorsDark()

    # setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]

    data = [rand()*0.2 for i = 1:100]
    label_interval_context = create_labelled_interval_context(data)


    while !GLFW.WindowShouldClose(window)

        GLFW.PollEvents()
        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        CImGui.Begin("Demo: Label Interval")
        @cstatic i1=Cint(1) i2=Cint(100) begin
        
        if isrunning(label_interval_context)
            !isnothing(label_interval_context) ? label_interval_context() : nothing
            control = label_interval_context.control
            i1 = Cint(get_start(control))
            i2 = Cint(get_stop(control))
        end
        CImGui.PushItemWidth(50)
        CImGui.SameLine()
        @c CImGui.DragInt("drag start", &i1, 1, 1, 100, "%d")
        CImGui.SameLine()
        @c CImGui.DragInt("drag stop", &i2, 1, 1, 100, "%d")
        i1 = i1 < i2 ? i1 : i2
        i2 = i2 > i1 ? i2 : i1
        if !isnothing(label_interval_context)
            control = label_interval_context.control
            set_start!(control, i1)
            set_stop!(control, i2)
        end
        CImGui.PopItemWidth()
        end

        CImGui.End()

        # rendering
        CImGui.Render()
        GLFW.MakeContextCurrent(window)
        display_w, display_h = GLFW.GetFramebufferSize(window)
        glViewport(0, 0, display_w, display_h)
        glClearColor(clear_color...)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())

        GLFW.MakeContextCurrent(window)
        GLFW.SwapBuffers(window)
    end

    # cleanup
    ImGui_ImplOpenGL3_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(ctx)
    GLFW.DestroyWindow(window)
end



# Run the demo
 label_interval_example()
