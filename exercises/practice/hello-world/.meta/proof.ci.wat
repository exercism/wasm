(module
  (import "env" "linearMemory" (memory 1))

  ;; This is a C-style string. The \00 character is a "null terminator" that
  ;; indicates the end of the string. Be sure not to delete it!
  (data (i32.const 200) "Hello, World!\00")
  
  (func (export "hello") (result i32)
    (i32.const 200)
  )
)
