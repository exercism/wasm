(module
  (memory (export "mem") 1)

  (global $ZERO i32 (i32.const 48))
  (global $ONE i32 (i32.const 49))
  (global $NINE i32 (i32.const 57))

  (func (export "clean") (param $textOffset i32) (param $textLength i32) (result i32 i32)

    (local $index i32)
    (local $stop i32)
    (local $dest i32)
    (local $value i32)
    (local $start i32)

    (local.set $index (local.get $textOffset))
    (local.set $stop
      (i32.add
        (local.get $textOffset)
        (local.get $textLength)
      )
    )
    (local.set $dest (local.get $textOffset))

    (loop $process
      (if (i32.lt_u (local.get $index) (local.get $stop)) (then
        (local.set $value
          (i32.load8_u (local.get $index))
        )
        (local.set $index
          (i32.add
            (local.get $index)
            (i32.const 1)
          )
        )

        (br_if
          $process
          (i32.lt_u (local.get $value) (global.get $ZERO))
        )

        (if (i32.gt_u (local.get $value) (global.get $NINE)) (then
          (return (i32.const 0) (i32.const 0))
        ))

        (i32.store8
          (local.get $dest)
          (local.get $value)
        )
        (local.set $dest
          (i32.add
            (local.get $dest)
            (i32.const 1)
          )
        )

        (br $process)
      ))
    )

    (local.set $start (local.get $textOffset))

    (if (i32.eq
          (local.get $dest)
          (i32.add (local.get $start) (i32.const 11))
        ) (then
      (if (i32.ne
            (i32.load8_u (local.get $start))
            (global.get $ONE)
          ) (then
        (return (i32.const 0) (i32.const 0))
      ))
      (local.set $start
        (i32.add
          (local.get $start)
          (i32.const 1)
        )
      )
    ))

    (if (i32.ne
          (local.get $dest)
          (i32.add (local.get $start) (i32.const 10))
        ) (then
      (return (i32.const 0) (i32.const 0))
    ))

    (if (i32.le_u
          (i32.load8_u (local.get $start))
          (global.get $ONE)
        ) (then
      (return (i32.const 0) (i32.const 0))
    ))

    (if (i32.le_u
          (i32.load8_u (i32.add (local.get $start) (i32.const 3)))
          (global.get $ONE)
        ) (then
      (return (i32.const 0) (i32.const 0))
    ))

    (return
      (local.get $start)
      (i32.sub
        (local.get $dest)
        (local.get $start)
      )
    )
  )
)
