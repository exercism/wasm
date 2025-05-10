(module
  (memory (export "mem") 1)

  (global $SPACE i32 (i32.const 32))
  (global $ZERO i32 (i32.const 48))
  (global $A i32 (i32.const 97))

  (global $outputOffset i32 (i32.const 320))

  ;;
  ;; Encode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "ciphertext") (param $offset i32) (param $length i32) (result i32 i32)
    (local $alphanumeric i32)
    (local $counter i32)
    (local $columns i32)
    (local $dest i32)
    (local $len i32)
    (local $position i32)
    (local $rows i32)
    (local $value i32)
    (local $digit i32)
    (local $letter i32)
    (local $source i32)
    (local $stop i32)

    (local.set $stop (i32.add (local.get $offset) (local.get $length)))

    (local.set $alphanumeric (local.get $length))
    (local.set $source (local.get $offset))
    (loop $read1
      (if (i32.lt_u (local.get $source) (local.get $stop)) (then
        (local.set $value (i32.load8_u (local.get $source)))
        (local.set $source (i32.add (local.get $source) (i32.const 1)))

        (local.set $digit (i32.sub (local.get $value) (global.get $ZERO)))
        (if (i32.ge_u (local.get $digit) (i32.const 10)) (then
          (local.set $letter
            (i32.sub
              (i32.or (local.get $value) (i32.const 32))
              (global.get $A)
            )
          )

          (if (i32.ge_u (local.get $letter) (i32.const 26)) (then
            (local.set $alphanumeric
              (i32.sub (local.get $alphanumeric) (i32.const 1)))
          ))
        ))
        (br $read1)
      ))
    )

    (if (i32.eqz (local.get $alphanumeric)) (then (
      return (i32.const 0) (i32.const 0))
    ))

    (local.set $columns (i32.const 0))
    (loop $col
      (local.set $columns (i32.add (local.get $columns) (i32.const 1)))
      (br_if $col (i32.lt_u (i32.mul (local.get $columns) (local.get $columns))
                            (local.get $alphanumeric)))
    )

    (local.set $rows
      (i32.div_u (i32.add (local.get $alphanumeric)
                          (i32.sub (local.get $columns) (i32.const 1)))
                 (local.get $columns)))
    (local.set $rows (i32.add (local.get $rows) (i32.const 1)))

    (local.set $len (i32.sub (i32.mul (local.get $rows) (local.get $columns))
                             (i32.const 1)))

    (local.set $dest (i32.add (global.get $outputOffset) (local.get $len)))

    (loop $spaces
      (local.set $dest (i32.sub (local.get $dest) (i32.const 1)))
      (i32.store8 (local.get $dest) (global.get $SPACE))
      (br_if $spaces (i32.ne (local.get $dest (global.get $outputOffset))))
    )

    (local.set $source (local.get $offset))
    (loop $write
      (local.set $counter (local.get $columns))
      (local.set $position (i32.const 0))

      (loop $read2
        (local.set $value (i32.load8_u (local.get $source)))
        (local.set $source (i32.add (local.get $source) (i32.const 1)))

        (local.set $digit (i32.sub (local.get $value) (global.get $ZERO)))
        (if (i32.ge_u (local.get $digit) (i32.const 10)) (then
          (local.set $letter
            (i32.sub
              (i32.or (local.get $value) (i32.const 32))
              (global.get $A)
            )
          )

          (if (i32.ge_u (local.get $letter) (i32.const 26)) (then
            (br $read2)
          ))
          (local.set $value (i32.or (local.get $value) (i32.const 32)))
        ))

        (i32.store8 (i32.add (local.get $dest) (local.get $position))
                    (local.get $value))
        (local.set $alphanumeric (i32.sub (local.get $alphanumeric)
                                          (i32.const 1)))

        (if (local.get $alphanumeric) (then
          (local.set $counter (i32.sub (local.get $counter) (i32.const 1)))
          (local.set $position (i32.add (local.get $position)
                                        (local.get $rows)))
          (br_if $read2 (local.get $counter))

          (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
          (br $write)
        ))
      )
    )

    (return (global.get $outputOffset) (local.get $len))
  )
)
