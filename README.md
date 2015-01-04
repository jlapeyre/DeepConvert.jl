# DeepConvert

This package provides convenient literal construction of values of
large data types.

It defines macros that define functions to convert all
numbers in an expression to a given numeric type and evaluate that
expression. (Like `deepcopy`, it traverses the entire expression tree.)
It is meant to allow a convenient way to input large
numbers without overflow.

The macros `@bigfloat`, `@bigint`, and `@int128` convert numeric literals
in their argument to BigFloat, BigInt or Int128. See examples below.

Two examples of non-standard AbstractString literals are exported,
`bf` and `bi`, which construct `BigFloat`s and
`BigInt`s from strings.

```julia
julia> BigInt[2^63,2^64]
2-element Array{BigInt,1}:  # awesome, an array of BigInt's!
 -9223372036854775808
                    0

julia> using DeepConvert
julia> a = bi"[2^63, 2^64]"
2-element Array{BigInt,1}:
  9223372036854775808
 18446744073709551616

julia> @bigint [2^63, 2^64]
2-element Array{BigInt,1}:
  9223372036854775808
 18446744073709551616
```

```julia
julia> @int128 binomial(100,50)
100891344545564193334812497256
```

```julia
julia> round(bf"((1+2e-50)-(1+1e-50))/(1e-50)")
1e+00 with 256 bits of precision
```

`deepbigfloat` takes an expression or string as an argument and acts on literals

```julia
julia> a = parse("1+1")
:(1 + 1)

julia> deepbigfloat(a)
2e+00 with 256 bits of precision

julia> deepbigfloat("1+1")
2e+00 with 256 bits of precision
```

## @mkdeepconvert(funcname, convfunc)

### Example

Define a function that converts Reals in an expression
to Int128

```julia
julia> using DeepConvert

julia> int128(2 * (10^19 + 10^17))  # does not do what you want
1753255926290448384

julia> @mkdeepconvert(convint128,int128)
convint128 (generic function with 3 methods)

julia> convint128(:( 2 * (10^19 + 10^17) )) # does what you want
20200000000000000000

julia> convint128( "2 * (10^19 + 10^17)" )  # can use double quotes, as well
20200000000000000000

julia> @mkdeepconvert(convuint64,uint64)
convuint64 (generic function with 3 methods)

julia> convuint64(:( 10^19 + 10^17 ))
0x8c2a687ce7720000
```

## @mkdeepconvert1(funcname, convfunc)

Unlike @mkdeepconvert, @mkdeepconvert1 converts numerators and
denominators of `Rational`s resulting in a `Rational` of a
different type.  @mkdeepconvert converts the entire `Rational` to
another type.

### Example

```julia
julia> @mkdeepconvert(conv128a, int128)
conv128a (generic function with 3 methods)

julia> resa = conv128a(:( 1//4 ))
0

julia> typeof(resa)
Int128

julia> @mkdeepconvert1(conv128b, int128)
conv128b (generic function with 3 methods)

julia> resb = conv128b(:( 1//4 ))
1//4

julia> typeof(resb)
Rational{Int128} (constructor with 1 method)
```

## bi, bf non-standard AbstractString literals

`bi` is implemented by

```julia
@mkdeepconvert(deepbigint,BigInt)
macro bi_str(s) deepbigint(s) end 
```

## @bigint, @int128

This is another experiment. Any Int and Int128 values in the
expression following `@bigint` are converted to `BigInt`. A contrived
example:

```julia
@bigint function g(x)
           return 2^64 * x
        end
```
Gives this,

```julia
julia> g(2.0)
3.6893488147419103232e+19 with 256 bits of precision
```

To override the macro, you have to ask for the smaller type,

```julia
@bigint function g(x)
           return int(2)^int(64) * x   # always returns zero
        end
```

In effect, this temporarily makes `BigInt` the default integer type.


<!--  LocalWords:  DeepConvert AbstractString BigFloat BigInt julia
 -->
<!--  LocalWords:  BigInt's mkdeepconvert funcname convfunc convint
 -->
<!--  LocalWords:  convuint uint ce conv resa typeof resb deepbigint
 -->
<!--  LocalWords:  str
 -->
