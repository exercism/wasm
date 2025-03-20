(module
  (memory (export "mem") 1)

  ;;
  ;; Provide the numbers for Pascals triangle with a given number of rows
  ;;
  ;; @param {i32} $count - number of rows
  ;;
  ;; @returns {(i32,i32)} - offset and length of the i32-numbers in linear memory
  ;;
  (func (export "rows") (param $count i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)