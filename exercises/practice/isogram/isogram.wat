(module
  (memory (export "mem") 1)

  ;;
  ;; Determine if a word or phrase is an isogram.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if pangram, 0 otherwise
  ;;
  (func (export "isIsogram") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
