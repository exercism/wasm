(module
  (func (export "eggCount") (param $number i32) (result i32)
    (local $remaining i32)
    (local $count i32)

    (if (i32.eq (local.get $number) (i32.const 0))(then
      (return (i32.const 0))
    ))

    (local.set $remaining (local.get $number))
    (local.set $count (i32.const 0))

    ;; do while $remaining != 0
    (loop
      ;; Clear least-significant 1 bit using
      ;; $remaining -= $remaining & -$remaining
      (local.set $remaining (i32.sub (local.get $remaining) (i32.and (local.get $remaining) (i32.sub (i32.const 0) (local.get $remaining)))))
      (local.set $count (i32.add (local.get $count) (i32.const 1)))
      (br_if 0 (i32.ne (local.get $remaining) (i32.const 0)))
    )

    (return (local.get $count))
  )
)
