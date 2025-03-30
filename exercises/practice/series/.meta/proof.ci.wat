(module
  (memory (export "mem") 1)

  ;; error codes
  (global $emptyInput i32 (i32.const -1))
  (global $tooLongSlice i32 (i32.const -2))
  (global $zeroSlice i32 (i32.const -3))
  (global $negativeSlice i32 (i32.const -4))

  (global $outputOffset i32 (i32.const 512))
  (global $zero i32 (i32.const 48))

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
    (local $outputLength i32)
    (local $pos i32)
    (local $index i32)
    (if (i32.eqz (local.get $inputLength)) (then (return (global.get $emptyInput) (i32.const 0))))
    (if (i32.eqz (local.get $sliceLength)) (then (return (global.get $zeroSlice) (i32.const 0))))
    (if (i32.lt_s (local.get $sliceLength) (i32.const 0)) (then 
      (return (global.get $negativeSlice) (i32.const 0))))
    (if (i32.gt_s (local.get $sliceLength) (local.get $inputLength)) (then
      (return (global.get $tooLongSlice) (i32.const 0))))
    (loop $slice
      (local.set $index (i32.const 0))
      (loop $number
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
          (i32.sub (i32.load8_u (i32.add (local.get $inputOffset)
            (i32.add (local.get $pos) (local.get $index)))) (global.get $zero)))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $index (i32.add (local.get $index) (i32.const 1)))
      (br_if $number (i32.lt_u (local.get $index) (local.get $sliceLength))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))    
    (br_if $slice (i32.le_u (i32.add (local.get $pos) (local.get $sliceLength))
      (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)
