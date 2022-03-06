(module
  (memory (export "mem") 1)

  (func (export "compute") 
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    (local $i i32)
    (local $differences i32)

    (local.set $i (i32.const 0))
    (local.set $differences (i32.const 0))

    ;; Strands must be of equal length
    (if (i32.ne (local.get $firstLength) (local.get $secondLength)) (then
      (return (i32.const -1))
    ))

    (if (i32.ge_u (local.get $firstLength) (i32.const 0)) (then (loop
      (if (i32.ne
        (i32.load8_u (i32.add (local.get $firstOffset) (local.get $i)))
        (i32.load8_u (i32.add (local.get $secondOffset) (local.get $i)))
      ) (then
        (local.set $differences (i32.add (local.get $differences) (i32.const 1)))
      ))
      (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $firstLength)))
    )))

    (local.get $differences)
  )
)
