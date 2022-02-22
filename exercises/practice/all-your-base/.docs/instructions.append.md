## Reserved Addresses

All input is provided as parameters, so no addresses in the linear memory are reserved.

## Relevant Debugging Imports

### Log an variable containing an integer

```wasm
(import "console" "log_i32_s" (func $log_i32_s (param i32)))
```

And then log as follows:

```wasm
(call $log_i32_s (local.get $i))
```
