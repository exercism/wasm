(module
  (memory (export "mem") 1)

  ;;
  ;; Truncate UTF-8 input string to 5 characters
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the truncated string in linear memory
  ;;
  (func (export "truncate") (param $offset i32) (param $length i32) (result i32 i32)

    (local $index i32)
    (local $stop i32)
    (local $remaining i32)
    (local $byte i32)
    (local $step i32)

    (local.set $index (local.get $offset))
    (local.set $stop
      (i32.add
        (local.get $offset)
        (local.get $length)
      )
    )
    (local.set $remaining (i32.const 5))

    (loop
      (if (i32.or (i32.eqz (local.get $remaining))
                  (i32.eq (local.get $index) (local.get $stop)))
        (then (return (local.get $offset)
                      (i32.sub (local.get $index) (local.get $offset)))
        )
      )

      (local.set
        $remaining
        (i32.sub
          (local.get $remaining)
          (i32.const 1)
        )
      )

      (local.set $byte (i32.load8_u (local.get $index)))

      (if (i32.eq (i32.const 0xf0) (i32.and (i32.const 0xf0) (local.get $byte)))
        (then
          (local.set $step (i32.const 4))
        )
        (else
          (if (i32.eq (i32.const 0xe0) (i32.and (i32.const 0xe0) (local.get $byte)))
            (then
              (local.set $step (i32.const 3))
            )
            (else
              (if (i32.eq (i32.const 0xc0) (i32.and (i32.const 0xc0) (local.get $byte)))
                (then
                  (local.set $step (i32.const 2))
                )
                (else
                  (local.set $step (i32.const 1))
                )
              )
            )
          )
        )
      )

      (local.set
        $index
        (i32.add
          (local.get $index)
          (local.get $step)
        )
      )

      (br 0)
    )
    (unreachable)
  )
)
