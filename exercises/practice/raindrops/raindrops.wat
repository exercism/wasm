;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory (export "mem") 1)

  (func (export "convert") (param $input i32) (result i32 i32)
    (return (i32.const 0) (i32.const 0))
  )
)
