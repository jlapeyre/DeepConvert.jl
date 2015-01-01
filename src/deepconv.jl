export @mkdeepconvert3

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
        ($f)(x::String) = ($f)(parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end


isstringint(ex::Expr) = ex.head == :macrocall &&
    (ex.args[1] == symbol("@int128_str") || ex.args[1] == symbol("@bigint_str"))
    

macro mkdeepconvert3(ff, ccfunc, targtype)
    f = esc(ff); cfunc = esc(ccfunc)
    quote
        function $(f)(ex::Expr)
            isstringint(ex) && return Expr(:call,$cfunc,ex)
            Expr(ex.head, map(
             (x) ->
             begin
               tx = typeof(x)
               tx <: $targtype  && return ($cfunc)(x)
               return tx == Expr ?
                   (isstringint(ex) ? Expr(:call,$cfunc,ex) : ($f)(x)) : x
             end,
             ex.args)...)
        end
        ($f)(x::String) = ($f)(parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end


macro mkdeepconvert4(ff, ccfunc, targtype)
    f = esc(ff)
    cfunc = esc(ccfunc)
    quote
        function $(f)(ex::Expr)
            println("Got $ex !!!!")
            if ex.head == :macrocall &&
                (ex.args[1] == symbol("@int128_str")
                 || ex.args[1] == symbol("@bigint_str"))
                println("New branch")
                return Expr(:call,$cfunc,ex)
            end
             Expr(ex.head, map(
              (x) ->
             begin
               println("Working expr on $x")                                   
               tx = typeof(x)
               if tx <: $targtype
                   return ($cfunc)(x)
               elseif  tx == Expr
                   if x.head == :macrocall &&
                       (x.args[1] == symbol("@int128_str")
                        || x.args[1] == symbol("@bigint_str"))
                       println("New branch *2*")
                       return Expr(:call,$cfunc,x)
                   else
                       return ($f)(x)
                   end
               else
                   return x
               end
             end,
             ex.args)...)
        end
        ($f)(x::String) = ($f)(parse(x))
        ($f)(x) = ($cfunc)(x)
    end
end
