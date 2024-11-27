# Instructions

After each generation, the cells interact with their eight neighbors, which are cells adjacent horizontally, vertically, or diagonally.

The following rules are applied to each cell:

- Any live cell with two or three live neighbors lives on.
- Any dead cell with exactly three live neighbors becomes a live cell.
- All other cells die or stay dead.

Given an array of 1s and 0s (corresponding to live and dead cells) and the number of cols and rows, apply these rules to each cell, and return the next generation as an offset of an u8 array or 1s and 0s with the same length.

```js
// test data
[
    [0, 0, 0],
    [0, 0, 0],
    [1, 1, 1]
]

// wasm data (* refers to the offset)
*Uint8Array[0, 0, 0, 0, 0, 0, 1, 1, 1] (i32.const 3) (i32.const 3)
```

You should be aware of the edges of your matrix represented as an array and need to prevent non-neighbors to leak into your count.
