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

@mkdeepconvert2(deepbigint2,BigInt,Union(Int,Int128))

macro int128(s)
    return quote
        $(esc(deepint128(s)))        
    end
end

@mkdeepconvert2(deepint128,int128,Union(Int64,Int32,Uint64,Uint32))
