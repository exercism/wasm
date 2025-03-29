(module
  (memory (export "mem") 1)

  ;; error codes
  (global $emptyInput i32 (i32.const -1))
  (global $tooLongSlice i32 (i32.const -2))
  (global $zeroSlice i32 (i32.const -3))
  (global $negativeSlice i32 (i32.const -4))

  ;;
  ;; Creates slices of u8 numbers from a UTF8 string of numbers
  ;;
  ;; @param {i32} $inputOffset - offset of the number string in linear memory
  ;; @param {i32} $inputLength - length of the number string in linear memory
  ;; @param {i32} $sliceLength - length of the slices
  ;;
  ;; @returns {(i32,i32)} - output offset or error code and length of the slices
  ;;
  (func (export "slices") (param $inputOffset i32) (param $inputLength i32) (param $sliceLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
