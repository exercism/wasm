(module
  (memory (export "mem") 1)
  
  (data (i32.const 0) "\6b\62\6e\62\64\72\65\6f\77\79\6e\67\65\62\74\76\79\67\65\77kiloohmsmegaohmsgigaohms")
  
  (global $zero i32 (i32.const 48))
  (global $space i32 (i32.const 32))

  ;;
  ;; Converts a single color code, as used on resistors, to a numeric value.
  ;;
  ;; @param {i32} offset - start of the color string.
  ;; @param {i32} length - length of the color string.
  ;;
  ;; @returns {i32} - the numeric value of the color code.
  ;;
  (func $colorCode (param $offset i32) (param $length i32) (result i32)
    (local $chars i32)
    (local $num i32)
    (local.set $chars (i32.or (i32.shl (i32.load8_u (local.get $offset)) (i32.const 8))
      (i32.load8_u (i32.add (local.get $offset) (i32.sub (local.get $length) (i32.const 1))))))
    (loop $numbers
      (if (i32.eq (local.get $chars) (i32.load16_u (i32.shl (local.get $num) (i32.const 1))))
        (then (return (local.get $num))))
      (local.set $num (i32.add (local.get $num) (i32.const 1)))
    (br_if $numbers (i32.le_u (local.get $num) (i32.const 10))))
    (return (i32.const -1))
  )

  ;;
  ;; Converts color codes, as used on resistors, to a string showing the value and unit.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;; @param {i32} thirdOffset - The offset of the third string in linear memory.
  ;; @param {i32} thirdLength - The length of the third string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the resistance specified 
  ;;                        by the color codes as a string in linear memory;
  ;;                        erroneous inputs receive an empty string
  ;;
  (func (export "value")
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32)
    (param $thirdOffset i32) (param $thirdLength i32) (result i32 i32)
    (local $digit i32)
    (local $mantissa i32)
    (local $exponent i32)
    (local $outputLength i32)
    (local.set $mantissa (call $colorCode (local.get $firstOffset) (local.get $firstLength)))
    (if (i32.eq (local.get $mantissa) (i32.const -1)) (then (return (i32.const 0) (i32.const 0))))
    (local.set $digit (call $colorCode (local.get $secondOffset) (local.get $secondLength)))
    (if (i32.eq (local.get $digit) (i32.const -1)) (then (return (i32.const 0) (i32.const 0))))
    (local.set $mantissa (i32.add 
      (i32.mul (local.get $mantissa) (i32.const 10)) (local.get $digit)))
    (local.set $exponent (call $colorCode (local.get $thirdOffset) (local.get $thirdLength)))
    (if (i32.eq (local.get $exponent) (i32.const -1)) (then (return (i32.const 0) (i32.const 0))))
    (if (i32.eqz (i32.rem_u (local.get $mantissa) (i32.const 10))) (then
      (local.set $mantissa (i32.div_u (local.get $mantissa) (i32.const 10)))
      (local.set $exponent (i32.add (local.get $exponent) (i32.const 1)))
    ))
    (if (i32.ge_u (local.get $mantissa) (i32.const 10)) (then
      (i32.store8 (i32.const 100)
        (i32.add (i32.div_u (local.get $mantissa) (i32.const 10)) (global.get $zero)))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    ))
    (i32.store8 (i32.add (i32.const 100) (local.get $outputLength))
      (i32.add (i32.rem_u (local.get $mantissa) (i32.const 10)) (global.get $zero)))
    (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    (if (i32.gt_u (i32.rem_u (local.get $exponent) (i32.const 3)) (i32.const 1)) (then
      (i32.store8 (i32.add (i32.const 100) (local.get $outputLength)) (global.get $zero))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    ))
    (if (i32.ge_u (i32.rem_u (local.get $exponent) (i32.const 3)) (i32.const 1)) (then
      (i32.store8 (i32.add (i32.const 100) (local.get $outputLength)) (global.get $zero))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    ))
    (i32.store8 (i32.add (i32.const 100) (local.get $outputLength)) (global.get $space))
    (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    (local.set $exponent (i32.div_u (local.get $exponent) (i32.const 3)))
    (if (local.get $exponent) (then
      (memory.copy (i32.add (i32.const 100) (local.get $outputLength))
        (i32.add (i32.const 12) (i32.shl (local.get $exponent) (i32.const 3))) (i32.const 8))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 8)))
    ) (else
      (memory.copy (i32.add (i32.const 100) (local.get $outputLength)) (i32.const 24) (i32.const 4))
      (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 4)))
    ))
    (i32.const 100) (local.get $outputLength)
  )
)
