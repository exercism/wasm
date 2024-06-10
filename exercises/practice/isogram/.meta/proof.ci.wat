(module
  (memory (export "mem") 1)

  (func (export "isIsogram") (param $offset i32) (param $length i32) (result i32)
    (local $index i32)
    (local $stop i32)
    (local $letter i32)
    (local $bitset i32)
    (local $updated i32)

    (local.set $index (local.get $offset))
    (local.set $stop
      (i32.add
        (local.get $offset)
        (local.get $length)
      )
    )
    (local.set $bitset (i32.const 0))

    (loop $process
      (if (i32.eq (local.get $index)
                  (local.get $stop)) (then
        (return (i32.const 1))
      ))

      (local.set $letter (i32.sub (i32.or (i32.load8_u (local.get $index))
                                          (i32.const 32))
                                  (i32.const 97)))

      (local.set $index
        (i32.add (local.get $index) (i32.const 1))
      )

      (if (i32.ge_u (local.get $letter)
                    (i32.const 26)) (then
        (br $process)
      ))

      (local.set $updated (i32.or (i32.shl (i32.const 1)
                                           (local.get $letter))
                                  (local.get $bitset)))

      (if (i32.eq (local.get $updated)
                  (local.get $bitset)) (then
        (return (i32.const 0))
      ))

      (local.set $bitset (local.get $updated))

      (br $process)
    )

    (unreachable)
  )
)
