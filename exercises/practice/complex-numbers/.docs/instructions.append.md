# Instruction append

The exponentiation of complex numbers requires an exponential function, a sine and a cosine function, none of which are available in WebAssembly. Fortunately, one can use a [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series) to calculate these. You should at least have 25+ steps of precision to align with the expected values.

## Exponential function

```
exp(n) = 1 + n + n ^ 2 / 2! + n ^ 3 / 3! + n ^ 4 / 4! + ... + n ^ x / x!
```

## Sine function

```
sin(n) = n - n ^ 3 / 3! + n ^ 5 / 5! - n ^ 7 / 7! + ... - n ^ x / x!
```

## Cosine function

```
cos(n) = 1 - n ^ 2 / 2! + n ^ 4 / 4! - n ^ 6 / 6! + ... - n ^ x / x!
```
