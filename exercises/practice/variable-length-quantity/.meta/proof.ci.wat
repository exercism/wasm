(module
  (memory (export "mem") 1)

  (global $incompleteSequence i32 (i32.const -1))
  (global $outputOffset i32 (i32.const 512))

  ;;
  ;; Encode u32 values into u8 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u32 value array in linear memory
  ;; @param {i32} $inputLength - length of u32 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of u8 value array in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $index i32)
    (local $value i32)
    (local $bytes i32)
    (local $outputLength i32)
    (loop $values
      (local.set $value (i32.load (i32.add (local.get $inputOffset)
        (i32.shl (local.get $index) (i32.const 2)))))
      (local.set $bytes (i32.div_s (i32.sub (i32.const 31) (i32.clz (local.get $value))) (i32.const 7)))
      (if (i32.lt_s (local.get $bytes) (i32.const 0)) (then (local.set $bytes (i32.const 0))))
      (loop $byte
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (i32.or 
          (i32.shr_u (local.get $value) (i32.mul (local.get $bytes) (i32.const 7)))
            (select (i32.const 128) (i32.const 0) (local.get $bytes))))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $value (i32.and (local.get $value)
          (i32.sub (i32.shl (i32.const 1) (i32.mul (local.get $bytes) (i32.const 7))) (i32.const 1))))
        (local.set $bytes (i32.sub (local.get $bytes) (i32.const 1)))
      (br_if $byte (i32.ge_s (local.get $bytes) (i32.const 0))))
      (local.set $index (i32.add (local.get $index) (i32.const 1)))
    (br_if $values (i32.lt_u (local.get $index) (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )

  ;;
  ;; Decode u8 values into u32 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u8 value array in linear memory
  ;; @param {i32} $inputLength - length of u8 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of u32 value array in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $index i32)
    (local $value i32)
    (local $outputLength i32)
    (local $buffer i32)
    (local $open i32)
    (loop $values
      (local.set $value (i32.load8_u (i32.add (local.get $inputOffset) (local.get $index))))
      (local.set $open (i32.and (local.get $value) (i32.const 128)))
      (local.set $buffer (i32.or (i32.shl (local.get $buffer) (i32.const 7))
        (i32.and (local.get $value) (i32.const 127))))
      (if (i32.eqz (i32.and (local.get $value) (i32.const 128))) (then
        (i32.store (i32.add (global.get $outputOffset)
          (i32.shl (local.get $outputLength) (i32.const 2))) (local.get $buffer))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $buffer (i32.const 0))))
      (local.set $index (i32.add (local.get $index) (i32.const 1)))
    (br_if $values (i32.lt_u (local.get $index) (local.get $inputLength))))
    (select (global.get $incompleteSequence) (global.get $outputOffset) (local.get $open))
    (local.get $outputLength)
  )
)
