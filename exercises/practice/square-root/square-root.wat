;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;;
  ;; Return the square root of the given number.
  ;;
  ;; @param {i32} radicand
  ;;
  ;; @returns {i32} square root of radicand
  ;;
  (func (export "squareRoot") (param $radicand i32) (result i32)
    (return (i32.const 42))
  )
)
