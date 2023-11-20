(module
  (memory (export "mem") 1)

  ;;
  ;; Given a string X, return a string that says "One for X, one for me."
  ;; If the X is empty, return the string "One for you, one for me."
  ;;
  ;; @param {i32} $offset - The offset of the name in linear memory.
  ;; @param {i32} $length - The length of the name in linear memory.
  ;; 
  ;; @return {(i32,i32)} - The offset and length the resulting string in linear memory.
  ;;
  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (return (i32.const 8) (i32.const 0))
  )
)
