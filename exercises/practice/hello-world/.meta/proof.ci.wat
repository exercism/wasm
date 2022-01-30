(module
  (import "env" "linearMemory" (memory 1))

  ;; Calls an imported JavaScript function that encodes a JavaString from linear memory
  ;; first parameter is the offset of first character of the string
  ;; second parameter is the length fo the string
  (import "env" "buildHostString" (func $build_host_string (param i32) (param i32)))

  (global $string_base_offset i32 (i32.const 200))
  (global $string_len i32 (i32.const 13))
  (data (i32.const 200) "Hello, World!")
  
  (func (export "hello") 
    (call $build_host_string (global.get $string_base_offset) (global.get $string_len))
  )
)