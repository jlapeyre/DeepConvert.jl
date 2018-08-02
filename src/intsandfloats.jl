export @mkdeepconvert, @mkdeepconvert1, @mkdeepconvert2, @bi_str, @bf_str, @bigint, @int128
export deepbigint2, deepbigfloat
export @bigfloat

@mkdeepconvert1(deepbigint, BigInt)
macro bi_str(s) deepbigint(s) end
_deepbigfloat(x::Real) = parse(BigFloat, string(x))
@mkdeepconvert(deepbigfloat,_deepbigfloat)
macro bf_str(s) deepbigfloat(s) end
macro bigint(s)
    return quote
        $(esc(deepbigint2(s)))
    end
end
macro bigfloat(s)
    return quote
        $(esc(deepbigfloat(s)))
    end
end

@mkdeepconvert3(deepbigint2, BigInt, Int)
# hmm, this does not work
@mkdeepconvert3(deepbigfloat2, BigFloat, Real)

macro int128(s)
    return quote
        $(esc(deepint128(s)))
    end
end

@mkdeepconvert3(deepint128, Int128, Int)
