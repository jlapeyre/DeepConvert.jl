# ff is the name of the function to be generated.
# ccfunc is the existing function that does the conversion.
macro mkdeepconvert(ff, ccfunc)
    f = esc(ff)
    cfunc = esc(ccfunc)
    quote
        function ($f)(ex::Expr)
            if ex.args[1] == ://
                return ($cfunc)(eval(ex))
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
        ($f)(x::String) = ($f)(parse(x))
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
        ($f)(x::String) = ($f)(parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end
