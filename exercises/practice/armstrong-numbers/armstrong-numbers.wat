;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (i32.const 42)
  )
)
