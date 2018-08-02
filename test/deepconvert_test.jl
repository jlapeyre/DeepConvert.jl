@testset "Float64" begin
    @mkdeepconvert(convfloat, Float64)
    @test convfloat(:(1//4)) == 0.25
    @test convfloat(:(1//4 + 0)) == 0.25
    @test convfloat("2^63") == 9.223372036854776e18
end

@testset "Int128" begin
    @mkdeepconvert(conv128, Int128)
    resa = conv128(:(1//4))
    @test  resa == 1//4
    @test typeof(resa) == Rational{Int128}

    @test conv128(:(2^64)) == Int128(2)^64
    @test conv128(:(2^64 + 2^17)) == Int128(2)^64 + 2^17
    @test conv128("2^64 + 2^17") == Int128(2)^64 + 2^17

    @test conv128(1) == 1
    @test typeof(conv128(1)) == Int128
    @test conv128("1") == 1
    @test typeof(conv128("1")) == Int128
    @test conv128("2^63") == Int128(2)^63

    @test typeof(@int128( 23432432 // 3)) == Rational{Int128}

end

@testset "BigInt" begin
    aa = BigInt[BigInt(2)^64, BigInt(2)^63]
    @test aa == bi"[2^64, 2^63]"
    @test bi"(10^53 - 1) // 9"  == (BigInt(10)^53-1)//9
    @test typeof( @bigint 111111111111111111111111111) == BigInt
    @test typeof( @bigint(111111111111111111111111111 + 8)) == BigInt
    @test typeof(1111111111111111111111111 // 3) == Rational{Int128}
    @test typeof(@bigint(1111111111111111111111111 // 3)) == Rational{BigInt}

    @bigint function gg(x)
           2^64 * x
    end
    y = gg(1.0)
    @test typeof(y) == BigFloat
    @test y > 0
end

@testset "BigFloat" begin
    @test bf"1e-50+1" == parse(BigFloat, "1e-50") + BigFloat(1)
    @test (BigFloat(1) * BigFloat(10)^-10 -  @bigfloat 1/10^10) == 0
    a = Meta.parse("1+1")
    @test deepbigfloat(a) == BigFloat(2)
    @test deepbigfloat("1+1") == BigFloat(2)
end

@testset "UInt64" begin
    @mkdeepconvert(convuint64, UInt64)
    res = convuint64("10^19 + 10^17")
    @test res == 0x8c2a687ce7720000
    @test typeof(res) == UInt64
end
