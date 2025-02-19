# Instruction append

The exponentiation of complex numbers requires an exponential function, a sine and a cosine function, none of which are available in WebAssembly. Fortunately, one can use a [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series) to calculate these. You should at least have `1/26!` precision to align with the expected values.

## Exponential function

```
exp(x) ≃ 1 + x + x ^ 2 / 2! + x ^ 3 / 3! + x ^ 4 / 4! + ... + x ^ n / n!
```

## Sine function

```
sin(x) ≃ x - x ^ 3 / 3! + x ^ 5 / 5! - x ^ 7 / 7! + ... - x ^ n / n!
```

## Cosine function

```
cos(x) ≃ 1 - x ^ 2 / 2! + x ^ 4 / 4! - x ^ 6 / 6! + ... - x ^ n / n!
```
