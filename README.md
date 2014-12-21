# DeepConvert

[![Build Status](https://travis-ci.org/jlapeyre/DeepConvert.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/DeepConvert.jl)

This package provides convenient literal construction of values of
large data types.

It defines macros that define functions to convert all
numbers in an expression to a given numeric type and evaluate that
expression. It is meant to allow a convenient way to input large
numbers without overflow.

Two examples of non-standard AbstractString literals are exported,
```bf``` and ```bi```, which construct ```BigFloat```s and
```BigInt```s from strings.

```julia
julia> BigInt[2^63,2^64]    # an array of BigInt's!
2-element Array{BigInt,1}:
 -9223372036854775808
                    0

julia> using DeepConvert
julia> a = bi"[2^63, 2^64]"
2-element Array{BigInt,1}:
  9223372036854775808
 18446744073709551616
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
denominators of ```Rational```s resulting in a ```Rational``` of a
different type.  @mkdeepconvert converts the entire ```Rational``` to
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
