using CImGui
using CImGui.CSyntax
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using CImGuiExtensions
using DataFrames # For this example, don't forget to add this package.
using Printf


struct UnspecifiedSchema <: AbstractSchema end

function create_import_context(keystr::String)
    # The controller is responsible for instantiating the dialog GUI,
    # handling user input and tiggering the file importer once the user
    # confirms the selection of a particular file.
    control = FileDialogControl(true)
    # The model store the path that the user has confirmed, as well as the
    # path that the user has selected but not necessarily confirmed.
    model = FileDialogModel(Path(pwd(),""), Path(pwd(),""))
    # The display properties include the title of the file dialog and what
    # action string is to be displayed on the button.
    properties = FileDialogDisplayProperties(caption = "Open File###"*keystr, action = "Open###"*keystr, width = Cfloat(520), height = Cfloat(210))
    # The importer is triggered once the user has confirmed the selection of a
    # particular path.
    load_csv = CSVImporter(false, UnspecifiedSchema())
    # Construct a context and assign roles to complete the requisite import interactions.
    ImportContext(control, model, properties, load_csv)
end

function open_file_example()

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

    data::Union{Nothing, DataFrame} = nothing
    # The string will be used to distingush between different open file dialogs
    # in case you ever need to have more than one file dialog active on the
    # screen.
    import_csv_key = "Import Generic CSV File"
    import_csv = create_import_context(import_csv_key)


    while !GLFW.WindowShouldClose(window)

        GLFW.PollEvents()
        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        CImGui.Begin("Demo: Open CSV File")
        if CImGui.Button("Open File Dialog")
            enable!(import_csv)
        end
        data₀::Union{Nothing, DataFrame}  = import_csv()
        # isrunning(import_csv) == true while the user is browsing for
        # the file. Once they click "Open" or "Cancel" isrunning(import_csv)
        # will return false.
        if !isrunning(import_csv) && !isnothing(data₀)
            data = data₀
            # You might trigger some other event or set a flag to true now
            # that the data has been loaded and is available for use.
            # Here we just display the data in the REPL.
            display(data)
            # Disable the import use-case once you are finished.
            disable!(import_csv)
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
 open_file_example()
