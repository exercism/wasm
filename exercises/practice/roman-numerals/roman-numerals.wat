(module
  (memory (export "mem") 1)

  ;;
  ;; Convert a number into a Roman numeral
  ;;
  ;; @param {i32} number - The number to convert
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "roman") (param $number i32) (result i32 i32)
    (return (i32.const 0) (i32.const 0))
  )
)
