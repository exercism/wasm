(module
  (memory (export "mem") 1)

  (global $ZERO i32 (i32.const 48))

  ;;
  ;; Calculate the largest product for a contiguous substring of digits of length n.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} largest digit product
  ;;
  (func (export "largestProduct") (param $offset i32) (param $length i32) (param $span i32) (result i32)
    (local $product i32)
    (local $stop i32)
    (local $start i32)
    (local $result i32)
    (local $index i32)
    (local $digit i32)

    (if (i32.or (i32.lt_s (local.get $span) (i32.const 0))
                (i32.gt_s (local.get $span) (local.get $length))) (then
      (return (i32.const -1))
    ))

    (if (i32.eqz (local.get $length)) (then
      (return (i32.const 1))
    ))

    (local.set $stop (i32.add (local.get $offset) (local.get $length)))

    (local.set $index (local.get $offset))
    (loop
      (local.set $digit (i32.sub (i32.load8_u (local.get $index))
                                 (global.get $ZERO)))
      (if (i32.gt_u (local.get $digit) (i32.const 9)) (then
        ;; $digit is not a valid digit.
        (return (i32.const -1))
      ))
      (i32.store8 (local.get $index) (local.get $digit))

      (local.set $index (i32.add (local.get $index) (i32.const 1)))
      (br_if 0 (i32.lt_u (local.get $index) (local.get $stop)))
    )

    (if (i32.eqz (local.get $span)) (then
      (return (i32.const 1))
    ))

    (local.set $result (i32.const 0))

    (local.set $start (i32.sub (local.get $stop) (local.get $span)))
    (loop $outer
      (local.set $product (i32.const 1))
      (local.set $index (local.get $start))
      (loop $inner
        (local.set $product (i32.mul (local.get $product)
                                     (i32.load8_u (local.get $index))))
        (local.set $index (i32.add (local.get $index) (i32.const 1)))
        (br_if $inner (i32.lt_u (local.get $index) (local.get $stop)))
      )
      (if (i32.lt_u (local.get $result) (local.get $product)) (then
        (local.set $result (local.get $product))
      ))

      (if (i32.eq (local.get $start) (local.get $offset)) (then
        (return (local.get $result))
      ))

      (local.set $start (i32.sub (local.get $start) (i32.const 1)))
      (local.set $stop (i32.sub (local.get $stop) (i32.const 1)))
      (br $outer)
    )
    (unreachable)
  )
)
