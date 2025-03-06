# Instruction append

The exponentiation of rational numbers with a real number requires calculating number to the power of a non-integer, a functionality that is not natively available in WebAssembly.

However, you can also express `x ^ y` as `x ^ y = exp(y * log(x))`.

And fortunately, one can use different series to calculate the exponential and the natural logarithm.

## Exponential function

The best solution for the exponential is a [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series):

```
exp(x) ≃ 1 + x + x ^ 2 / 2! + x ^ 3 / 3! + x ^ 4 / 4! + ... + x ^ n / n!
```

## Logarithm function (for positive x)

There are multiple ways to efficiently calculate a natural logarithm. One of them is a series based on an [Inverse Hyperbolic Tangent](https://en.wikipedia.org/wiki/Logarithm#Inverse_hyperbolic_tangent):

```
log(x) / 2 ≃ y + y ^ 3 / 3 + y ^ 5 / 5 + ... + y ^ n / n where y = (x - 1) / (x + 1)
```

There is also another Taylor Series to calculate the natural logarithm:

```
log(x) = (x - 1) - (x - 1) ^ 2 / 2 + (x  - 1) ^ 3 / 3 - (x - 1) ^ 4 / 4 ... + (x - 1) ^ n / n
```

It is only accurate for `x` between 0 and 2. However we can also use `log(x) = - log(1 / x)`

## Integer exponentiation

For integer exponentiation, better use multiplication and either a loop or recursion, both for performance and precision reasons. For extra performance, one can use [Horner's method](https://en.wikipedia.org/wiki/Horner%27s_method) to reduce the number of multiplications.
