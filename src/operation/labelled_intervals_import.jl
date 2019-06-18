# Import Labelled Intervals
function (load::CSVImporter{<:CSVSchema{<: GenericVendor, <: GenericProduct, <: IntervalLabels}})(path::Path)
    disable!(load)
    df = load_dataframe(path)
    _, ncol = size(df)
    if ncol != 6
        CImGui.OpenPopup("Have you opened the appropriate file?")
        return nothing
    else
        dict = Dict{String, LabelledInterval}()
        for row in eachrow(df)
            label = row[:label]
            start = Float64(row[:start])
            stop = Float64(row[:stop])
            i₀ = row[:first]
            s = row[:step]
            i₁ = row[:last]
            interval = i₀:s:i₁
            dict[label] = LabelledInterval(label, NestedInterval(start = start, stop = stop, interval = interval))
        end
        return LabelledIntervals("Conditions", dict)
    end
end
