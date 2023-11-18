;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;; Returns 1 if leap year, 0 otherwise
  (func (export "isLeap") (param $year i32) (result i32)
    (i32.const 42)
  )  
)
