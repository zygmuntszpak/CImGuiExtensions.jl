function (store::CSVExporter{<:AbstractSchema})(path::Path, li::LabelledIntervals)
    # Convert labelled intervals to a dataframe.
    labelled_intervals = get_labelled_intervals(li)
    df = DataFrame(label = String[], start = Int64[], stop = Int64[], first = Float64[], step = Float64[], last  = Float64[])
    for (key, labelled_interval) in pairs(labelled_intervals)
        nested_interval = labelled_interval.nested_interval
        start = get_start(nested_interval)
        stop = get_stop(nested_interval)
        interval = get_interval(nested_interval)
        push!(df, [key start stop first(interval) step(interval) last(interval)])
    end
    Base.display(df)
    store(path, df)
end
