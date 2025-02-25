# Instruction append

The exponentiation of rational numbers with a real number requires calculating number to the power of a non-integer, a functionality that is not natively available in WebAssembly.

However, you can also express `x ^ y` as `x ^ y = exp(y * log(x))`.

And fortunately, one can use a [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series) to calculate the exponential and the logarithmic functions. You should at least have `1/26!` precision for the exponential function and `1/260` for the logarithm to align with the expected values.

## Exponential function

```
exp(x) ≃ 1 + x + x ^ 2 / 2! + x ^ 3 / 3! + x ^ 4 / 4! + ... + x ^ n / n!
```

## Logarithm function (for positive x)

```
log(x) ≃ (x - 1) / (x + 1) + ((x - 1) / (x + 1)) ^ 3 / 3 + ((x - 1) / (x + 1)) ^ 5 / 5 + ... + ((x - 1) / (x + 1)) ^ n / n
```

For integer exponentiation, better use multiplication and either a loop or recursion, both for performance and precision reasons.
