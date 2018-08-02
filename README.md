# DeepConvert

*convenient literal construction of values of large data types*

<!-- [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://jlapeyre.github.io/DeepConvert.jl/latest) -->
Linux, OSX: [![Build Status](https://travis-ci.org/jlapeyre/DeepConvert.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/DeepConvert.jl)
&nbsp;
Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/github/jlapeyre/DeepConvert.jl?branch=master&svg=true)](https://ci.appveyor.com/project/jlapeyre/deepconvert-jl)
&nbsp; &nbsp; &nbsp;
[![Coverage Status](https://coveralls.io/repos/jlapeyre/DeepConvert.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/DeepConvert.jl?branch=master)
[![codecov.io](http://codecov.io/github/jlapeyre/DeepConvert.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/DeepConvert.jl?branch=master)

Most of the following is also in this [Jupyter notebook](https://github.com/jlapeyre/DeepConvert.jl/blob/master/Notebooks/DeepConvert.ipynb).

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
`BigInt`s from strings. Note that these are *not* the same as the string
literal `big` in Julia `Base`.

```julia
julia> BigInt[2^63, 2^64]
2-element Array{BigInt,1}:  # awesome, an array of BigInt's!
 -9223372036854775808
                    0

julia> using DeepConvert
julia> bi"[2^63, 2^64]"
2-element Array{BigInt,1}:
  9223372036854775808
 18446744073709551616

julia> @bigint [2^63, 2^64]
2-element Array{BigInt,1}:
  9223372036854775808
 18446744073709551616
```

```julia
julia> binomial(100, 50)
ERROR: OverflowError: binomial(100, 50) overflows

julia> @int128 binomial(100, 50)
100891344545564193334812497256
```

```julia
julia> round(bf"((1 + 2e-50) - (1 + 1e-50)) / (1e-50)")
1.0
```

`deepbigfloat` takes an expression or string as an argument and acts on literals

```julia
julia> a = parse("1 + 1")
:(1 + 1)

julia> deepbigfloat(a)
2e+00 with 256 bits of precision

julia> deepbigfloat("1 + 1")
2e+00 with 256 bits of precision
```

## @mkdeepconvert(funcname, convfunc)

### Example

Define a function that converts `Real`s in an expression
to Int128

```julia
julia> using DeepConvert

julia> Int128(2 * (10^19 + 10^17))  # does not do what you want
1753255926290448384

julia> @mkdeepconvert(convint128, Int128)
convint128 (generic function with 3 methods)

julia> convint128(:( 2 * (10^19 + 10^17) )) # does what you want
20200000000000000000

julia> convint128("2 * (10^19 + 10^17)")  # can use double quotes, as well
20200000000000000000

julia> @mkdeepconvert(convuint64, UInt64)
convuint64 (generic function with 3 methods)

julia> convuint64("10^19 + 10^17")
0x8c2a687ce7720000
```

## bi, bf non-standard AbstractString literals

`bi` is implemented by

```julia
@mkdeepconvert(deepbigint, BigInt)
macro bi_str(s) deepbigint(s) end
```

## @bigint, @int128

Any Int and Int128 values in the expression following `@bigint` are converted to `BigInt`. A contrived
example:

```julia
@bigint function g(x)
           return 2^64 * x
        end
```
Gives this,

```julia
julia> g(2.0)
3.6893488147419103232e+19
```

To override the macro, you have to ask for the smaller type,
```julia
@bigint function g(x)
           return Int(2)^Int(64) * x   # always returns zero
        end
```

In effect, this temporarily makes `BigInt` the default integer type.
<!--  LocalWords:  DeepConvert AbstractString BigFloat BigInt julia
 -->
<!--  LocalWords:  BigInt's mkdeepconvert funcname convfunc convint
 -->
<!--  LocalWords:  convuint uint ce conv resa typeof resb deepbigint
 -->
<!--  LocalWords:  str deepcopy bigint deepbigfloat
 -->
