;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (return (i32.const 42))
  )
)
