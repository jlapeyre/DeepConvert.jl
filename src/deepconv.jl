#export @mkdeepconvert3

isstringint(ex::Expr) = ex.head == :macrocall &&
    (ex.args[1] == Symbol("@int128_str") || ex.args[1] == Symbol("@bigint_str"))

macro mkdeepconvert(ff, ccfunc)
    f = esc(ff)
    cfunc = esc(ccfunc)
    quote
        function ($f)(ex::Expr)
            if ex.args[1] == ://
                evex = eval(ex)
                return convert(promote_type($cfunc, typeof(evex)), evex)
            else
              eval(Expr(ex.head, map(
              (x) ->
                begin
                    tx = typeof(x)
                    if tx <: Real
                        return ($cfunc)(x)
                    elseif  tx == Expr
                        return ($f)(x)
                    else
                        return x
                    end
                end,
               ex.args)...))
            end
        end
        ($f)(x::AbstractString) = ($f)(Meta.parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end

macro mkdeepconvert1(ff, ccfunc)
    f = esc(ff)
    cfunc = esc(ccfunc)
    quote
        function $(f)(ex::Expr)
             eval(Expr(ex.head, map(
              (x) ->
             begin
               tx = typeof(x)
               if tx <: Real
                   return ($cfunc)(x)
               elseif  tx == Expr
                       return ($f)(x)
               else
                   return x
               end
             end,
             ex.args)...))
        end
        ($f)(x::AbstractString) = ($f)(Meta.parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end

macro mkdeepconvert2(ff, ccfunc, targtype)
    f = esc(ff)
    cfunc = esc(ccfunc)
    quote
        function $(f)(ex::Expr)
             Expr(ex.head, map(
              (x) ->
             begin
               tx = typeof(x)
               if tx <: $targtype
                   return ($cfunc)(x)
               elseif  tx == Expr
                       return ($f)(x)
               else
                   return x
               end
             end,
             ex.args)...)
        end
        ($f)(x::AbstractString) = ($f)(Meta.parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end

# ff is the name of the function to be generated.
# ccfunc is the existing function that does the conversion.
macro mkdeepconvert3(ff, ccfunc, targtype)
   f = esc(ff); cfunc = esc(ccfunc)
   quote
     function $(f)(ex::Expr)
       isstringint(ex) && return Expr(:call, $cfunc, ex)
         Expr(ex.head, map((x) -> (typeof(x) <: $targtype ?
           ($cfunc)(x) : typeof(x) == Expr ? ($f)(x) : x), ex.args)...)
     end
     ($f)(x::AbstractString) = ($f)(Meta.parse(x))
     ($f)(x) = ($cfunc)(x)
   end
end
