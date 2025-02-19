(module
  (memory (export "mem") 1)

  ;;
  ;; translates text into pig latin
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputLength - length of the input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output in linear memory
  ;;
  (func (export "translate") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local.get $inputOffset) (local.get $inputLength)
  )
)