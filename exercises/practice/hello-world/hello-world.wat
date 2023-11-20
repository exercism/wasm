(module
  (memory (export "mem") 1)

  ;; Initializes the WebAssembly Linear Memory with a UTF-8 string of 14 characters starting at offset 64
  (data (i32.const 64) "Goodbye, Mars!")
  
  ;;
  ;; Return a greeting
  ;;
  ;; Note: The final number (currently “14”) must match the length of the new string!
  ;;
  ;; @returns {(i32, i32)} The offset and length of the greeting
  (func (export "hello") (result i32 i32)
    (i32.const 64) (i32.const 14)
  )
)
