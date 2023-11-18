;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  (memory (export "mem") 1)

  ;;
  ;; Determine if a string is a pangram.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if pangram, 0 otherwise
  ;;
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
