export deepbigint2

@mkdeepconvert1(deepbigint,BigInt)
macro bi_str(s) deepbigint(s) end

_deepbigfloat(x::Real) = BigFloat(string(x))
@mkdeepconvert(deepbigfloat,_deepbigfloat)
macro bf_str(s) deepbigfloat(s) end

macro bigint(s)
    return quote
        $(esc(deepbigint2(s)))        
    end
end

@mkdeepconvert3(deepbigint2,BigInt,Int)

macro int128(s)
    return quote
        $(esc(deepint128(s)))        
    end
end

# This is not really tested
@mkdeepconvert3(deepint128,int128,Int)
