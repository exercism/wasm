(module
  (memory (export "mem") 1)

  (global $SPACE i32 (i32.const 32))

  (global $ZERO i32 (i32.const 48))

  ;;
  ;; Checks if a string is valid per the Luhn formula.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid per Luhn formula, 0 otherwise
  ;;
  (func (export "valid") (param $offset i32) (param $length i32) (result i32)
    (local $count i32)
    (local $total i32)
    (local $index i32)
    (local $digit i32)

    (local.set $count (i32.const 0))
    (local.set $total (i32.const 0))

    ;; We traverse the string once, starting from the end.
    (local.set $index (i32.add (local.get $offset) (local.get $length)))
    (loop
      (if (i32.eq (local.get $index) (local.get $offset)) (then
        (return (i32.and (i32.gt_u (local.get $count) (i32.const 1))
                         (i32.eqz (i32.rem_u (local.get $total) (i32.const 10)))))
      ))

      (local.set $index (i32.sub (local.get $index) (i32.const 1)))
      (local.set $digit (i32.load8_u (local.get $index)))
      (br_if 0 (i32.eq (local.get $digit) (global.get $SPACE)))

      (local.set $digit (i32.sub (local.get $digit) (global.get $ZERO)))
      (if (i32.gt_u (local.get $digit) (i32.const 9)) (then
        ;; $digit is not a valid digit.
        (return (i32.const 0))
      ))
      (local.set $count (i32.add (local.get $count) (i32.const 1)))

      (if (i32.eqz (i32.rem_u (local.get $count) (i32.const 2))) (then
        (local.set $digit (i32.add (local.get $digit) (local.get $digit)))
        (if (i32.gt_u (local.get $digit) (i32.const 9)) (then
          (local.set $digit (i32.sub (local.get $digit) (i32.const 9)))
        ))
      ))

      (local.set $total (i32.add (local.get $total) (local.get $digit)))
      (br 0)
    )
    (unreachable)
  )
)
