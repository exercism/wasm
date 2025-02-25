(module
  (memory (export "mem") 1)

  ;;
  ;; Output a diamond made of letters.
  ;;
  ;; @param {i32} $letter - the character code of the letter in the middle of the diamond
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "rows") (param $letter i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)