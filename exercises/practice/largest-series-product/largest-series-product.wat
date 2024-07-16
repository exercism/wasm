(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the largest product for a contiguous substring of digits of length n.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} largest digit product
  ;;
  (func (export "largestProduct") (param $offset i32) (param $length i32) (param $span i32) (result i32)
    (return (i32.const 0))
  )
)
