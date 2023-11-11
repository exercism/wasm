# Instruction append

## WebAssembly-specific Notes

The function signature for the WebAssembly export `convert` is as follows:

```wasm
(func (export "convert")
    (param $arrOffset i32)
    (param $arrLength i32)
    (param $inputBase i32)
    (param $outputBase i32)
    (result i32 i32 i32)
)
```

The first two parameters `$arrOffset` and `$arrLength` express the base offset and length of an array of 32-bit signed integers. The length parameter is sized in number of elements in the array, not bytes. Prior to calling this function, the caller writes this array into the WebAssembly linear memory beginning at offset `$arrOffset`. WebAssembly linear memory is always expressed in little-endian. 

Thus the caller would thus encoded the array `[1,2]` as the following eight byte sequence.

```
| 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 |
| ---- arr[0] ----- | ---- arr[1] ----- |
,0x01,0x00,0x00,0x00,0x02,0x00,0x00,0x00,
```

The parameters `$inputBase` and `$outputBase` do not involve linear memory.

The result type is `(i32 i32 i32)`. The first two values are the `offset` and `length` of your output in linear memory. If you so choose, you may overwrite the addresses of linear memory used for the input. The third return value is an i32 status code used for error handling.

If the third return value expresses an error state, the unit tests do not read the first two return values.
