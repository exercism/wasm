(module
  (memory (export "mem") 1)

  (global $C i32 (i32.const 67))
  (global $D i32 (i32.const 68))
  (global $I i32 (i32.const 73))
  (global $L i32 (i32.const 76))
  (global $M i32 (i32.const 77))
  (global $V i32 (i32.const 86))
  (global $X i32 (i32.const 88))

  ;; returns the end offset
  (func $print (param $digit i32) (param $ten i32) (param $five i32) (param $one i32) (param $beginOffset i32) (result i32)
    (local $offset i32)
    (local $remainder i32)

    (local.set $offset (local.get $beginOffset))
    (local.set $remainder (i32.rem_u
                            (local.get $digit)
                            (i32.const 5)
    ))
    (if (i32.eq (local.get $remainder) (i32.const 4)) (then
      (i32.store8 (local.get $offset) (local.get $one))
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (if (i32.eq (local.get $digit) (i32.const 9)) (then
        (i32.store8 (local.get $offset) (local.get $ten))
      ) (else
        (i32.store8 (local.get $offset) (local.get $five))
      ))
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
    ) (else
      (if (i32.ge_u (local.get $digit) (i32.const 5)) (then
        (i32.store8 (local.get $offset) (local.get $five))
        (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      ))
      (if (local.get $remainder) (then
        (loop $ones
          (i32.store8 (local.get $offset) (local.get $one))
          (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
          (local.set $remainder (i32.sub (local.get $remainder) (i32.const 1)))
          (br_if $ones (local.get $remainder))
        )
      ))
    ))
    (return (local.get $offset))
  )

  ;;
  ;; Convert a number into a Roman numeral
  ;;
  ;; @param {i32} number - The number to convert
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "roman") (param $number i32) (result i32 i32)
    (local $returnOffset i32)
    (local $digit i32)
    (local $offset i32)

    (local.set $returnOffset (i32.const 100))
    (local.set $offset (local.get $returnOffset))

    (local.set $digit (i32.div_u
                        (local.get $number)
                        (i32.const 1000)
    ))
    (local.set $offset
      (call $print (local.get $digit) (global.get $X) (global.get $V) (global.get $M) (local.get $offset))
    )

    (local.set $digit (i32.rem_u
                        (i32.div_u (local.get $number) (i32.const 100))
                        (i32.const 10)
    ))
    (local.set $offset
      (call $print (local.get $digit) (global.get $M) (global.get $D) (global.get $C) (local.get $offset))
    )

    (local.set $digit (i32.rem_u
                        (i32.div_u (local.get $number) (i32.const 10))
                        (i32.const 10)
    ))
    (local.set $offset
      (call $print (local.get $digit) (global.get $C) (global.get $L) (global.get $X) (local.get $offset))
    )

    (local.set $digit (i32.rem_u
                        (local.get $number)
                        (i32.const 10)
    ))
    (local.set $offset
      (call $print (local.get $digit) (global.get $X) (global.get $V) (global.get $I) (local.get $offset))
    )

    (return
      (local.get $returnOffset)
      (i32.sub (local.get $offset) (local.get $returnOffset))
    )
  )
)
