(module
  (memory (export "mem") 1)

  ;;
  ;; Checks if a string is a valid ISBN-10 number.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid ISBN-10 number, 0 otherwise
  ;;
  (func (export "isValid") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
