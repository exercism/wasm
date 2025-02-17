

(module
  (memory (export "mem") 2)

  (data $digits (i32.const 0) "\77\24\5d\6d\2e\6b\7b\25\7f\6f")

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
    (local $inputPos i32)
    (local $lineLength i32)
    (local $lines i32)
    (local $digit i32)
    (local $outputPos i32)
    (local.set $lineLength (i32.const -1))
    (loop $measureLine 
      (local.set $lineLength (i32.add (local.get $lineLength) (i32.const 1)))
      (br_if $measureLine
        (i32.ne (i32.load8_u (i32.add (local.get $inputOffset) (local.get $lineLength)))
        (global.get $lineBreak)))
    )
    (loop $readDigits
      (local.set $lines (i32.or (i32.or (i32.or (i32.or (i32.or (i32.or
        (i32.eq (i32.load8_u 
          (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos)) (i32.const 1)))
          (global.get $horizontal))
        (i32.shl (i32.eq (i32.load8_u 
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (local.get $lineLength)) (i32.const 1)))
          (global.get $vertical)) (i32.const 1)))
        (i32.shl (i32.eq (i32.load8_u
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (local.get $lineLength)) (i32.const 3)))
          (global.get $vertical)) (i32.const 2)))
        (i32.shl (i32.eq (i32.load8_u
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (local.get $lineLength)) (i32.const 2)))
          (global.get $horizontal)) (i32.const 3)))
        (i32.shl (i32.eq (i32.load8_u
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (i32.shl (local.get $lineLength) (i32.const 1))) (i32.const 2)))
          (global.get $vertical)) (i32.const 4)))
        (i32.shl (i32.eq (i32.load8_u
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (i32.shl (local.get $lineLength) (i32.const 1))) (i32.const 4)))
          (global.get $vertical)) (i32.const 5)))
        (i32.shl (i32.eq (i32.load8_u
          (i32.add (i32.add (i32.add (local.get $inputOffset) (local.get $inputPos))
          (i32.shl (local.get $lineLength) (i32.const 1))) (i32.const 3)))
          (global.get $horizontal)) (i32.const 6))))
      (local.set $digit (i32.const -1))
      (loop $findDigit
        (local.set $digit (i32.add (local.get $digit) (i32.const 1)))
        (br_if $findDigit (i32.and (i32.lt_s (local.get $digit) (i32.const 10))
          (i32.ne (local.get $lines) (i32.load8_u (local.get $digit)))))
      )
      (i32.store8 (i32.add (i32.const 256) (local.get $outputPos))
        (select (i32.add (local.get $digit) (global.get $zero)) (global.get $unknown)
          (i32.lt_u (local.get $digit) (i32.const 10))))
      (local.set $outputPos (i32.add (local.get $outputPos) (i32.const 1)))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 3)))
      (if (i32.eqz (i32.rem_u (i32.add (local.get $inputPos) (i32.const 1))
        (i32.add (local.get $lineLength) (i32.const 1)))) (then
        (i32.store8 (i32.add (i32.const 256) (local.get $outputPos)) (global.get $comma))
        (local.set $outputPos (i32.add (local.get $outputPos) (i32.const 1)))
        (local.set $inputPos
          (i32.add (i32.add (local.get $inputPos) (i32.const 1))
          (i32.mul (i32.add (local.get $lineLength) (i32.const 1)) (i32.const 3))))
      ))
      (br_if $readDigits (i32.lt_u (local.get $inputPos) (local.get $inputLength)))
    )
    (i32.const 256) (i32.sub (local.get $outputPos) (i32.const 1))
  )
)
