;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory (export "mem") 1)

  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (return (local.get $offset) (local.get $length))
  )
)
