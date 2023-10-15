(module
  (func (export "squareRoot") (param $radicand i32) (result i32)
    ;; n*n
    (local $square i32)
    ;; 2*n+1
    (local $odd i32)

    (if (i32.eq (local.get $radicand) (i32.const 0))(then
      (return (i32.const 0))
    ))

    (local.set $square (i32.const 0))
    (local.set $odd (i32.const 1))

    ;; do while $square < $radicand
    (loop
      ;; n*n+2n+1 == (n+1)*(n+1)
      (local.set $square (i32.add (local.get $square) (local.get $odd)))
      ;; 2n+1+2 == 2(n+1)+1
      (local.set $odd (i32.add (local.get $odd) (i32.const 2)))
      (br_if 0 (i32.lt_u (local.get $square) (local.get $radicand)))
    )

    ;; Halve $odd (rounding down) to find n
    (return (i32.shr_u (local.get $odd) (i32.const 1)))
  )
)
