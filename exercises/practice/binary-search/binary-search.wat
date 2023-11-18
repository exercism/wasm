;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory (export "mem") 1)
 
  ;; Assumes size of i32
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (i32.const 42)
  )
)
