abstract type AbstractDisplayProperties end

Base.@kwdef mutable struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::Float64 = Float64(32)
    width::Float64 = Float64(320)
    heigh::Float64 = Float64(200)
end

dump(Base.@kwdef mutable struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::Float64 = Float64(32)
    width::Float64 = Float64(320)
    heigh::Float64 = Float64(200)
end)

@macroexpand Base.@kwdef mutable struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::Float64 = Float64(32)
    width::Float64 = Float64(320)
    heigh::Float64 = Float64(200)
end

@macroexpand @mytest Base.@kwdef mutable struct FileDialogDisplayProperties <: AbstractDisplayProperties
    caption::String
    action::String
    position::Float64 = Float64(32)
    width::Float64 = Float64(320)
    heigh::Float64 = Float64(200)
end

macro mytest(expr)
    expr = macroexpand(__module__, expr) # to expand @static
    kwdefs = dump(expr)

    # expr isa Expr && expr.head == :struct || error("Invalid usage of @kwdef")
    # T = expr.args[2]
    # if T isa Expr && T.head == :<:
    #     T = T.args[1]
    # end
    #
    # params_ex = Expr(:parameters)
    # call_args = Any[]
    #
    # kwdefs = nothing

    # _kwdef!(expr.args[3], params_ex.args, call_args)
    # # Only define a constructor if the type has fields, otherwise we'll get a stack
    # # overflow on construction
    # if !isempty(params_ex.args)
    #     if T isa Symbol
    #         kwdefs = :(($(esc(T)))($params_ex) = ($(esc(T)))($(call_args...)))
    #     elseif T isa Expr && T.head == :curly
    #         # if T == S{A<:AA,B<:BB}, define two methods
    #         #   S(...) = ...
    #         #   S{A,B}(...) where {A<:AA,B<:BB} = ...
    #         S = T.args[1]
    #         P = T.args[2:end]
    #         Q = [U isa Expr && U.head == :<: ? U.args[1] : U for U in P]
    #         SQ = :($S{$(Q...)})
    #         kwdefs = quote
    #             ($(esc(S)))($params_ex) =($(esc(S)))($(call_args...))
    #             ($(esc(SQ)))($params_ex) where {$(esc.(P)...)} =
    #                 ($(esc(SQ)))($(call_args...))
    #         end
    #     else
    #         error("Invalid usage of @kwdef")
    #     end
    # else
    #     kwdefs = nothing
    # end
    quote
        Base.@__doc__($(esc(expr)))
        $kwdefs
    end
end
