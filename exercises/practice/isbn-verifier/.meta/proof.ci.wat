(module
  (memory (export "mem") 1)

  (global $HYPHEN i32 (i32.const 45))

  (global $ZERO i32 (i32.const 48))

  (global $NINE i32 (i32.const 57))

  (global $X i32 (i32.const 88))

  ;;
  ;; Checks if a string is a valid ISBN-10 number.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid ISBN-10 number, 0 otherwise
  ;;
  (func (export "isValid") (param $offset i32) (param $length i32) (result i32)

    (local $index i32)
    (local $stop i32)
    (local $remaining i32)
    (local $value i32)
    (local $total i32)
    (local $weightedTotal i32)

    (local.set $index (local.get $offset))
    (local.set $stop
      (i32.add
        (local.get $offset)
        (local.get $length)
      )
    )
    (local.set $remaining (i32.const 10))
    (local.set $total (i32.const 0))
    (local.set $weightedTotal (i32.const 0))

    (loop
      (if (i32.eq (local.get $index) (local.get $stop))
        (then
          (return (i32.and (i32.eqz (local.get $remaining))
                           (i32.eqz (i32.rem_u (local.get $weightedTotal) (i32.const 11)))))
        )
      )

      (local.set $value (i32.load8_u (local.get $index)))

      (local.set
        $index
        (i32.add
          (local.get $index)
          (i32.const 1)
        )
      )

      (br_if 0 (i32.eq (local.get $value) (global.get $HYPHEN)))

      (local.set
        $remaining
        (i32.sub
          (local.get $remaining)
          (i32.const 1)
        )
      )

      (if (i32.or (i32.lt_u (local.get $value) (global.get $ZERO))
                  (i32.gt_u (local.get $value) (global.get $NINE)))
        (then
          (if (i32.and (i32.eq (local.get $value) (global.get $X))
                       (i32.eqz (local.get $remaining)))
            (then
              (local.set
                $value
                (i32.const 10)
              )
            )
            (else
              (return (i32.const 0))
            )
          )
        )
        (else
          (local.set
            $value
            (i32.sub
              (local.get $value)
              (global.get $ZERO)
            )
          )
        )
      )

      (local.set
        $total
        (i32.add
          (local.get $total)
          (local.get $value)
        )
      )

      (local.set
        $weightedTotal
        (i32.add
          (local.get $weightedTotal)
          (local.get $total)
        )
      )

      (br 0)
    )
    (unreachable)
  )
)
