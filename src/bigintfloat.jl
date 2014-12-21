@mkdeepconvert1(deepbigint,BigInt)
macro bi_str(s) deepbigint(s) end

_deepbigfloat(x::Real) = BigFloat(string(x))
@mkdeepconvert(deepbigfloat,_deepbigfloat)
macro bf_str(s) deepbigfloat(s) end
