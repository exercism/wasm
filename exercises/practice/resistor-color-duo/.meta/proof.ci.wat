(module
  (memory (export "mem") 1)

  (global $C i32 (i32.const 67))
  (global $G i32 (i32.const 71))
  (global $O i32 (i32.const 79))
  (global $R i32 (i32.const 82))
  (global $V i32 (i32.const 86))
  (global $W i32 (i32.const 87))
  (global $Y i32 (i32.const 89))

  ;;
  ;; Given a valid resistor color, returns the associated value
  ;;
  ;; @param {i32} offset - offset into the color buffer
  ;; @param {i32} len - length of the color string
  ;;
  ;; @returns {i32} - the associated value
  ;;
  (func $colorCode (param $offset i32) (param $len i32) (result i32)
    (local $first i32)
    (local $fourth i32)

    ;; First letter in color buffer, forced to upper case
    (local.set $first (i32.and
                        (i32.load8_u (local.get $offset))
                        (i32.const 223)
    ))

    ;; Fourth letter in color buffer, forced to upper case
    (local.set $fourth (i32.and
                         (i32.load8_u (i32.add
                           (local.get $offset)
                           (i32.const 3)
                         ))
                         (i32.const 223)
    ))
    (if (i32.eq (local.get $first) (global.get $R)) (then
      (return (i32.const 2))
    ))
    (if (i32.eq (local.get $first) (global.get $O)) (then
      (return (i32.const 3))
    ))
    (if (i32.eq (local.get $first) (global.get $Y)) (then
      (return (i32.const 4))
    ))
    (if (i32.eq (local.get $first) (global.get $V)) (then
      (return (i32.const 7))
    ))
    (if (i32.eq (local.get $first) (global.get $W)) (then
      (return (i32.const 9))
    ))

    (if (i32.eq (local.get $first) (global.get $G)) (then
      (if (i32.eq (local.get $fourth) (global.get $Y)) (then
        (return (i32.const 8))
      ))
      (return (i32.const 5))
    ))

    (if (i32.eq (local.get $fourth) (global.get $C)) (then
      (return (i32.const 0))
    ))
    (if (i32.eq (local.get $fourth) (global.get $W)) (then
      (return (i32.const 1))
    ))
    (return (i32.const 6))
  )

  ;;
  ;; Converts a pair of color codes, as used on resistors, to a numeric value.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;;
  ;; @returns {i32} - The numeric value specified by the color codes.
  ;;
  (func (export "value")
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    (return (i32.add
              (i32.mul
                (call $colorCode (local.get $firstOffset) (local.get $firstLength))
                (i32.const 10)
              )
              (call $colorCode (local.get $secondOffset) (local.get $secondLength))
    ))
  )
)
