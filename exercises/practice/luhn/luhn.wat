(module
  (memory (export "mem") 1)

  ;;
  ;; Checks if a string is valid per the Luhn formula.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid per Luhn formula, 0 otherwise
  ;;
  (func (export "valid") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
