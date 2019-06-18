using CImGui
using CImGui.CSyntax
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using Printf
using ImageCore


function construct_B()
    B = repeat(1:500, 1, 401)
    low = colorant"navyblue";
    medium = colorant"limegreen";
    high = colorant"yellow";
    Bcolormap = colorsigned(low,medium,high) ∘ scalesigned(minimum(B),(minimum(B)+maximum(B)) / 2, maximum(B))
    Bcolormap.(B)
end

function example(B::AbstractArray)
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


    # create texture for image drawing
    img₀ = B
    img₁= transpose(img₀)
    img_width, img_height = size(img₁)
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
    image_id = ImGui_ImplOpenGL3_CreateImageTexture(img_width, img_height, format = GL_RGBA)
    img′ = unsafe_wrap(Array{UInt8,3}, convert(Ptr{UInt8}, pointer(img₁)), (Cint(3), Cint(img_width), Cint(img_height)))
    ImGui_ImplOpenGL3_UpdateImageTexture(image_id, img′, img_width, img_height; format = GL_RGB)


    # setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    demo_open = true
    clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]
    while !GLFW.WindowShouldClose(window)
        demo_open # oh my global scope
        image_id, img_width, img_height

        GLFW.PollEvents()
        # start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        CImGui.Begin("Image Demo")
            CImGui.Image(Ptr{Cvoid}(image_id), (img_width, img_height))
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
example(construct_B())
