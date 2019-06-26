mutable struct PlotlinesControl <: AbstractControl
    isenabled::Bool
end

function (control::PlotlinesControl)(model::PlotlinesModel, properties::PlotlinesDisplayProperties)
    id = get_id(properties)
    captioner = get_captioner(properties)
    caption = captioner(nothing)
    col = get_col(properties)
    rectangle = get_layout(properties)
    xaxis = get_xaxis(properties)
    yaxis = get_yaxis(properties)
    pos = CImGui.GetCursorScreenPos()
    totalwidth = get_width(rectangle)
    totalheight = get_height(rectangle)
    padding = get_padding(properties)
    data = get_data(model)
    CImGui.Dummy(ImVec2(0, padding[1]))
    padding[2] == 0 ? nothing : CImGui.Indent(padding[2])
    width = totalwidth - padding[2]
    height = totalheight
    CImGui.PlotLines(id, data , length(data), 0 , caption, minimum(data), maximum(data), (width, height))
    isenabled(xaxis) ? draw_horizontal_ticks(data, width, height, get_ytick(properties)) : nothing
    isenabled(yaxis) ? draw_vertical_ticks(data, width, height, get_xtick(properties)) : nothing
    padding[2] == 0 ? nothing : CImGui.Unindent(padding[2])
end

function draw_vertical_ticks(data, width, height, tick::Tickmark)
    if isenabled(tick)
        # Draw the x-axis
        draw_list = CImGui.GetWindowDrawList()
        black = Base.convert(ImU32, ImVec4(0,0, 0, 1))
        pos = CImGui.GetCursorScreenPos()
        CImGui.AddLine(draw_list, pos, ImVec2(pos.x + width, pos.y), black, get_thickness(tick));
        # Draw the concomitant tick marks.
        x = pos.x
        y = pos.y
        interpret = get_interpreter(tick)
        # for xₙ in range(x, stop = x + width; length = floor(Int, width / get_spacing(tick)) )
        #     # This line represents the tick mark.
        #     CImGui.AddLine(draw_list, ImVec2(xₙ, y), ImVec2(xₙ, y + get_length(tick)), black, get_thickness(tick)) #TODO add tick direction
        #     # Display value associated with that tickmark
        #     index = round(Int,stretch_linearly(xₙ, x,  x + width, 1, length(data)))
        #     # Convert the raw data to a text description after applying the
        #     # transformation associated with the value2text function.
        #     str = string(interpret(index))
        #     xoffset = div(length(str) * CImGui.GetFontSize(), 4)
        #     yoffset = get_length(tick) + 2
        #     CImGui.AddText(draw_list, ImVec2(xₙ - xoffset, y + yoffset), black, "$str",);
        # end
        gap = floor(Int, width / get_spacing(tick))
        increment = round(Int, stretch_linearly(gap , 1, width, 1, length(data)))
        for index in 1:increment:length(data)
            xₙ = Cfloat(stretch_linearly(index , 1, length(data), x,  x + width))
            # This line represents the tick mark.
            CImGui.AddLine(draw_list, ImVec2(xₙ, y), ImVec2(xₙ, y + get_length(tick)), black, get_thickness(tick)) #TODO add tick direction
            # Display value associated with that tickmark
            # Convert the raw data to a text description after applying the
            # transformation associated with the value2text function.
            str = string(interpret(index))
            xoffset = div(length(str) * CImGui.GetFontSize(), 4)
            yoffset = get_length(tick) + 2
            CImGui.AddText(draw_list, ImVec2(xₙ - xoffset, y + yoffset), black, "$str",);
        end
    end
end

function draw_horizontal_ticks(data, width, height, tick::Tickmark)

    if isenabled(tick)
        draw_list = CImGui.GetWindowDrawList()
        black = Base.convert(ImU32, ImVec4(0,0, 0, 1))
        col = Base.convert(ImU32, ImVec4(0.95,0.1, 0.1, 0.1))
        pos = CImGui.GetCursorScreenPos()
        # Draw the y-axis
        CImGui.AddLine(draw_list, pos, ImVec2(pos.x, pos.y - height), black, get_thickness(tick));
        minval = minimum(data)
        maxval = maximum(data)
        # Draw the concomitant tick marks.
        x = pos.x
        y = pos.y
        interpret = get_interpreter(tick)
        # TODO: Perhaps better to iterate over bonafide values and round pixel coordinates?
        span = range(y - height, stop = y; length = floor(Int, height / get_spacing(tick)))
        count = 1
        for yₙ in span
            # This line represents the tick mark.
            CImGui.AddLine(draw_list, ImVec2(x, yₙ), ImVec2(x - get_length(tick), yₙ), black, get_thickness(tick)); #TODO add tick direction
            # Display value associated with that tickmark
            val = round(stretch_linearly(yₙ, y,  y - height, minval, maxval); digits = 3)
            # Convert the raw data to a text description after applying the
            # transformation associated with the value2text function.
            str = string(interpret(val))
            xoffset = get_length(tick) + 3 + div(length(str) * CImGui.GetFontSize(), 2)
            yoffset = div(CImGui.GetFontSize(), 2)
            CImGui.AddText(draw_list, ImVec2(x - xoffset, yₙ - yoffset), black, "$str",);
            # Draw a faint filled rectangle as a visual guide for every second row
            if iseven(count)
                 CImGui.AddRectFilled(draw_list, ImVec2(x, yₙ), ImVec2(x + width, yₙ + step(span)), col);
            end
            count += 1
        end
    end
end
