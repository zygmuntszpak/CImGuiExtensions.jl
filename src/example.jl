using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using CImGui: ImVec2, ImVec4, IM_COL32, ImU32
using CImGuiExtensions


function filedialog_example()

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
    window = GLFW.CreateWindow(1280, 720, "ElectroDermal Activity Analysis")
    @assert window != C_NULL
    GLFW.MakeContextCurrent(window)
    GLFW.SwapInterval(1)  # enable vsync

    # setup Dear ImGui context
    ctx = CImGui.CreateContext()

    # setup Dear ImGui style
    CImGui.StyleColorsLight()

    # setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    # Instantiate variables that are used to control input and output
    # of various widges.
    clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]



    # # The controller is responsible for instantiating the dialog GUI,
    # # handling user input and tiggering the file importer once the user
    # # confirms the selection of a particular file.
    # control = FileDialogControl(true)
    # # The model store the path that the user has confirmed, as well as the
    # # path that the user has selected but not necessarily confirmed.
    # model = FileDialogModel(Path(pwd(),"hello"), Path(pwd(),"hello"))
    # # The display properties include the title of the file dialog and what
    # # action string is to be displayed on the button.
    # properties = FileDialogDisplayProperties("Open File###CSV", "Open###CSV", ImVec2(0,0), 100, 100)
    # # The importer is triggered once the user has confirmed the selection of a
    # # particular path.
    # load_csv = CSVImporter(false)
    #
    #
    #
    # control₂ =  FileDialogControl(true)
    # model₂ = FileDialogModel(Path(pwd(),"hello"), Path(pwd(),"hello"))
    # properties₂ = FileDialogDisplayProperties("Open File###Image", "Open###Image", ImVec2(0,0), 100, 100)
    # load_image = ImageImporter(false)

    # The controller is responsible for instantiating the dialog GUI,
    # handling user input and tiggering the file importer once the user
    # confirms the selection of a particular file.
    control = FileDialogControl(true)
    # The model store the path that the user has confirmed, as well as the
    # path that the user has selected but not necessarily confirmed.
    model = FileDialogModel(Path(pwd(),""), Path(pwd(),""))
    # The display properties include the title of the file dialog and what
    # action string is to be displayed on the button.
    properties = FileDialogDisplayProperties("Open File###CSV", "Open###CSV", ImVec2(0,0), 100, 100)
    # The importer is triggered once the user has confirmed the selection of a
    # particular path.
    load_csv = CSVImporter(false, CSVSchema(Empatica(), E4(), SkinConductance()))

    #mvcs = Vector{ModelViewControl}(undef, 0)
    mvc = ModelViewControl(control, model, properties, load_csv)
    #push!(mvcs, mvc)



    control₂ =  FileDialogControl(true)
    model₂ = FileDialogModel(Path(pwd(),"hello"), Path(pwd(),"hello"))
    properties₂ = FileDialogDisplayProperties("Open File###Image", "Open###Image", ImVec2(0,0), 100, 100)
    load_image = ImageImporter(false)

    mvc₂ = ModelViewControl(control₂, model₂, properties₂, load_image)
    #push!(mvcs, mvc₂)

    mvcs = Dict{String, ModelViewControl}()
    mvcs["load_empatica_eda"] = mvc
    mvcs["load_image"] = mvc₂

    data = nothing
    while !GLFW.WindowShouldClose(window)
        GLFW.PollEvents()
        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        for (key, model_view_control) in pairs(mvcs)
            model_view_control()
        end

        # Load new data based on user selection.
        data = isenabled(load_csv) ? load_csv(get_path(model, ConfirmedStatus())) : data

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

filedialog_example()
