

(module
  (memory (export "mem") 2)

  (data $digits (i32.const 0) "\77\24\5d\6d\2e\6b\7b\25\7f\6f")

  (global $lineBreak i32 (i32.const 10))
  (global $vertical i32 (i32.const 124))
  (global $horizontal i32 (i32.const 95))
  (global $zero i32 (i32.const 48))
  (global $unknown i32 (i32.const 63))
  (global $comma i32 (i32.const 44))
  (global $outputOffset i32 (i32.const 256))

  ;;
  ;; Converts 7-bit multi-character numbers into a number string
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputLength - length of the input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of output in linear memory
  (func (export "convert") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $inputPos i32)
    (local $inputPtr i32)
    (local $lineLength i32)
    (local $lines i32)
    (local $digit i32)
    (local $outputLength i32)
    (local.set $lineLength (i32.const -1))
    (loop $measureLine 
      (local.set $lineLength (i32.add (local.get $lineLength) (i32.const 1)))
      (br_if $measureLine
        (i32.ne (i32.load8_u (i32.add (local.get $inputOffset)
                (local.get $lineLength)))
        (global.get $lineBreak)))
    )
    (local.set $lineLength (i32.add (local.get $lineLength) (i32.const 1)))
    (loop $readDigits
      (local.set $inputPtr (i32.add (local.get $inputOffset) (local.get $inputPos)))
      ;; generate bitmask from segments
      (local.set $lines (i32.or (i32.or (i32.or (i32.or (i32.or (i32.or
        ;; bit 1: top
        (i32.eq (i32.load8_u (i32.add (local.get $inputPtr) (i32.const 1)))
          (global.get $horizontal))
        ;; bit 2: upper left
        (i32.shl (i32.eq (i32.load8_u (i32.add (local.get $inputPtr)
          (local.get $lineLength))) (global.get $vertical)) (i32.const 1)))
        ;; bit 3: upper right
        (i32.shl (i32.eq (i32.load8_u (i32.add (i32.add (local.get $inputPtr)
          (local.get $lineLength)) (i32.const 2))) (global.get $vertical)) (i32.const 2)))
        ;; bit 4: middle
        (i32.shl (i32.eq (i32.load8_u (i32.add (i32.add (local.get $inputPtr)
          (local.get $lineLength)) (i32.const 1))) (global.get $horizontal)) (i32.const 3)))
        ;; bit 5: lower left
        (i32.shl (i32.eq (i32.load8_u (i32.add (local.get $inputPtr)
          (i32.shl (local.get $lineLength) (i32.const 1))))
          (global.get $vertical)) (i32.const 4)))
        ;; bit 6: lower right
        (i32.shl (i32.eq (i32.load8_u (i32.add (i32.add (local.get $inputPtr)
          (i32.shl (local.get $lineLength) (i32.const 1))) (i32.const 2)))
          (global.get $vertical)) (i32.const 5)))
        ;; bit 7: bottom
        (i32.shl (i32.eq (i32.load8_u (i32.add (i32.add (local.get $inputPtr)
          (i32.shl (local.get $lineLength) (i32.const 1))) (i32.const 1)))
          (global.get $horizontal)) (i32.const 6))))
      ;; bitmask index in data is number; 10 = not found ('?')
      (local.set $digit (i32.const -1))
      (loop $findDigit
        (local.set $digit (i32.add (local.get $digit) (i32.const 1)))
        (br_if $findDigit (i32.and (i32.lt_s (local.get $digit) (i32.const 10))
          (i32.ne (local.get $lines) (i32.load8_u (local.get $digit)))))
      )
      ;; write number or question mark
      (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
        (select (i32.add (local.get $digit) (global.get $zero)) (global.get $unknown)
          (i32.lt_u (local.get $digit) (i32.const 10))))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 3)))
      ;; line break
      (if (i32.eqz (i32.rem_u (i32.add (local.get $inputPos) (i32.const 1))
        (local.get $lineLength))) (then
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $comma))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $inputPos
          (i32.add (i32.add (local.get $inputPos) (i32.const 1))
          (i32.mul (local.get $lineLength) (i32.const 3))))
      ))
      (br_if $readDigits (i32.lt_u (local.get $inputPos) (local.get $inputLength)))
    )
    ;; remove superfluous ','
    (global.get $outputOffset) (i32.sub (local.get $outputLength) (i32.const 1))
  )
)
