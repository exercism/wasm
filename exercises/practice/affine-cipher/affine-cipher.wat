(module
  (memory (export "mem") 1)

  (global $notCoprimeError i32 (i32.const -1))

  ;;
  ;; encode text with affine cipher
  ;;
  ;; @param {i32} $inputOffset - offset of input text in linear memory
  ;; @param {i32} $inputLength - length of input text in linear memory
  ;; @param {i32} $keyA - first part of the key
  ;; @param {i32} $keyB - second part of the key
  ;;
  ;; @returns {(i32,i32)} - encoded output offset and length in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (param $keyA i32) (param $keyB i32) (result i32 i32)
    (i32.const 0) (global.get $notCoprimeError)
  )

  ;;
  ;; decode text with affine cipher
  ;;
  ;; @param {i32} $inputOffset - offset of input text in linear memory
  ;; @param {i32} $inputLength - length of input text in linear memory
  ;; @param {i32} $keyA - first part of the key
  ;; @param {i32} $keyB - second part of the key
  ;;
  ;; @returns {(i32,i32)} - decoded output offset and length in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (param $keyA i32) (param $keyB i32) (result i32 i32)
    (i32.const 0) (global.get $notCoprimeError)
  )
)