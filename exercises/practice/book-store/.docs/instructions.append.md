# Instruction append

## WebAssembly-specific Notes

The function signature for the WebAssembly export `total` is as follows:

```wasm
(func (export "total")
    (param $basketOffset i32)
    (param $basketLength i32)
    (result i32)
)
```

The two parameters `$basketOffset` and `$basketLength` express the base offset and length of an array of 32-bit integers. The length parameter is sized in number of elements in the array, not bytes. Prior to calling this function, the caller writes this array into the WebAssembly linear memory beginning at offset `$basketOffset`. WebAssembly linear memory is always expressed in little-endian.

For example, the caller would encode the basket `[1,2]` as the following eight byte sequence.

```
| 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 |
| --- basket[0] --- | --- basket[1] --- |
,0x01,0x00,0x00,0x00,0x02,0x00,0x00,0x00,
```
