using CImGuiExtensions
using GR

function launch_video()

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

    stream_webcam = false
    clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]
    show_another_window = true
    counter = 0


    # setup camera
    f = VideoIO.openvideo(video_file)
    # The OpenGL library expects RGBA UInt8 data layed out in a width x height format.
    texture₀ = ImGui_ImplOpenGL3_CreateImageTexture(f.width, f.height, format = GL_RGB)

    # Capture the first frame so that we can initialize a buffer to store each
    # frame that is read from the webcam.
    imageₙ = read(f)

    while !GLFW.WindowShouldClose(window)
        GLFW.PollEvents()
        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        CImGui.Begin("Image Demo")
        @c CImGui.Checkbox("Plot Data", &stream_webcam)

        if stream_webcam
            # consume the next camera frame
            !eof(f) && read!(f, imageₙ)
            imageₙ′ = unsafe_wrap(Array{UInt8,3}, convert(Ptr{UInt8}, pointer(imageₙ)), (Cint(3), f.width, f.height))
            ImGui_ImplOpenGL3_UpdateImageTexture(texture₀ , imageₙ′, f.width, f.height; format = GL_RGB)
            CImGui.Image(Ptr{Cvoid}(texture₀), (f.width, f.height))
        end

        CImGui.Text(@sprintf("Application average %.3f ms/frame (%.1f FPS)", 1000 / CImGui.GetIO().Framerate, CImGui.GetIO().Framerate))
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
    close(f)



end
