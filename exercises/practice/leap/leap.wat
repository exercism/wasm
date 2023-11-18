;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;;
  ;; Determine if a year is a leap year
  ;;
  ;; @param {i32} year - The year to check
  ;;
  ;; @returns {i32} 1 if leap year, 0 otherwise
  ;;
  (func (export "isLeap") (param $year i32) (result i32)
    (i32.const 42)
  )  
)
