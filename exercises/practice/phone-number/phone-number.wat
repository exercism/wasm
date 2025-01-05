(module
  (memory (export "mem") 1)

  ;;
  ;; Clean up user-entered phone number
  ;;
  ;; @param {i32} textOffset - The offset of the input string in linear memory
  ;; @param {i32} textLength - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the clean phone number in linear memory
  ;;
  (func (export "clean") (param $textOffset i32) (param $textLength i32) (result i32 i32)
    (return (local.get $textOffset) (local.get $textLength))
  )
)
