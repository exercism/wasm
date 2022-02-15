(module
  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $buffer i32)
    (local $numberOfDigits i32)
    (local $sum i32)
    (local $digit i32)
    (local $sumToPowerOfNumberOfDigits i32)
    (local $i i32)

    (if (i32.eq (local.get $candidate) (i32.const 0))(then
      (return (i32.const 1))
    ))
    
    ;; Get number of digits
    (local.set $buffer (local.get $candidate))
    (local.set $numberOfDigits (i32.const 0))
    (loop
      (local.set $numberOfDigits (i32.add (local.get $numberOfDigits) (i32.const 1)))  
      (br_if 0 (i32.gt_u (local.tee $buffer (i32.div_u (local.get $buffer) (i32.const 10))) (i32.const 0)))
    )

    ;; get sum of digits raised to power of number of digits
    (local.set $buffer (local.get $candidate))
    (local.set $sum (i32.const 0))
    (loop
      (local.set $sumToPowerOfNumberOfDigits (i32.const 1))
      (local.set $digit (i32.rem_u (local.get $buffer) (i32.const 10)))
      (if (i32.gt_u (local.get $digit) (i32.const 0))(then
        ;; Raise to digit to power of number of digits
        (local.set $i (i32.const 0))
        (loop
          (local.set $sumToPowerOfNumberOfDigits (i32.mul (local.get $sumToPowerOfNumberOfDigits) (local.get $digit)))
          (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $numberOfDigits)))
        )
        ;; Add to sum
        (local.set $sum (i32.add (local.get $sum) (local.get $sumToPowerOfNumberOfDigits)))
      ))
      (br_if 0 (i32.gt_u (local.tee $buffer (i32.div_u (local.get $buffer) (i32.const 10))) (i32.const 0)))
    )

    ;; compare with candidate
    (i32.eq (local.get $sum) (local.get $candidate))
  )
)
