;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory (export "mem") 1)

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (return (local.get $textOffset) (local.get $textLength))
  )
)
