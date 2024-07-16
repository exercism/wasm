(module
  (memory (export "mem") 1)

  ;;
  ;; Adds numbers to a minesweeper board.
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the output string in linear memory
  ;;
  (func (export "annotate") (param $offset i32) (param $length i32) (result i32 i32)
    (return (local.get $offset) (local.get $length))
  )
)
