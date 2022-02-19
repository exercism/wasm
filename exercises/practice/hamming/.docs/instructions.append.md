## Reserved Addresses

The buffer for the first string uses bytes 1024-2047 of linear memory.
The buffer for the second string uses bytes 2048-3075 of linear memory.

You should not have to modify these buffer or allocate additional memory

## Hints

WebAssembly lacks the sort of string library typically found in higher level languages. This means that you must manually implement functionality to:

- Check if a character is uppercase
- Check if a character is lowercase
- Check if a character is a letter
- Convert a lowercase letter to an uppercase letter

We encode characters in UTF-8 and limit input to ASCII character encoding.

Reference: https://en.wikipedia.org/wiki/ASCII

## Relevant Debugging Imports

### Log a string from linear memory

```wasm
(import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))
```

And then log as follows:

```wasm
(call $log_mem_as_utf8 (i32.const 64) (i32.const i28))
```

### Log an variable containing an integer

```wasm
(import "console" "log_i32_s" (func $log_i32_s (param i32)))
```

And then log as follows:

```wasm
(call $log_i32_s (local.get $i))
```
