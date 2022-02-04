(module
  (func $iterate (param $number i32) (param $step i32) (result i32)
    (if (i32.eq (local.get $number) (i32.const 1)) (then 
      (return (local.get $step))
    ))

    (if (i32.eq (i32.rem_s (local.get $number) (i32.const 2)) (i32.const 0)) (then
      (return (call $iterate 
        (i32.div_s (local.get $number) (i32.const 2))
        (i32.add (local.get $step) (i32.const 1))
      ))
    ) (else
      (return (call $iterate 
        (i32.add (i32.mul (i32.const 3) (local.get $number)) (i32.const 1))
        (i32.add (local.get $step) (i32.const 1))
      ))
    ))

    ;; indicates that the conditions above are exhaustive
    (unreachable)
    )
  
  (func (export "steps") (param $number i32) (result i32)
    (if (i32.le_s (local.get $number) (i32.const 0))(then
      (return (i32.const -1))
    ))

    (return (call $iterate (local.get $number) (i32.const 0)))
  )
)