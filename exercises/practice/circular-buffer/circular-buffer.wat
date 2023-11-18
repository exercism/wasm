;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory 1)
  ;; Add globals here!

  ;; newCapacity is a capacity between 0 and 1024
  ;; a WebAssembly page is 4096 bytes, so up to 1024 i32s
  ;; returns 0 on success or -1 on error 
  (func (export "init") (param $newCapacity i32) (result i32)
    (i32.const 42)
  )

  (func (export "clear")
    (nop)
  )

  ;; returns 0 on success or -1 on error 
  (func (export "write") (param $elem i32) (result i32)
    (i32.const 42)
  )

  ;; returns 0 on success or -1 on error 
  (func (export "forceWrite") (param $elem i32) (result i32)
    (i32.const 42)
  )

  ;; Returns Go-style error handling tuple (i32, i32)
  ;; The first element of the return tuple is the returned value or -1 on error 
  ;; The second element should be 0 on success or -1 on error
  (func (export "read") (result i32 i32)
    (return (i32.const 42) (i32.const 42))
  )
)
