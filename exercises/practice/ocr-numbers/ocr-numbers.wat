(module
  (memory (export "mem") 2)

  (global $lineBreak i32 (i32.const 10))
  (global $vertical i32 (i32.const 124))
  (global $horizontal i32 (i32.const 95))
  (global $zero i32 (i32.const 48))
  (global $unknown i32 (i32.const 63))
  (global $comma i32 (i32.const 44))

  ;;
  ;; Converts 7-bit multi-character numbers into a number string
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputLength - length of the input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of output in linear memory
  (func (export "convert") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local.get $inputOffset) (local.get $inputLength)
  )
)
