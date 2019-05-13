function stretch_linearly(x, A, B, a, b)
    (x-A) * ((b-a) / (B-A)) + a
end

function extract_string(buffer)
    first_nul = findfirst(isequal('\0'), buffer) - 1
    buffer[1:first_nul]
end
