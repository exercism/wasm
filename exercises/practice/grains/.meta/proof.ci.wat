(module
  ;; Result is unsigned
  (func $sqaure (export "square") (param $squareNum i64) (result i64)
    (if (i32.or 
      (i64.lt_s (local.get $squareNum) (i64.const 1)) 
      (i64.gt_s (local.get $squareNum) (i64.const 64))
    ) (then
      (return (i64.const 0))
    ))

    (i64.shl (i64.const 1) (i64.sub (local.get $squareNum) (i64.const 1)))
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $sum i64)
    (local $squareNum i64)
    (local $squareVal i64)
    (local.set $sum (i64.const 0))

    (if (i64.le_u (local.tee $squareNum (i64.const 1)) (i64.const 64)) (then
      (loop
        
        (if (i64.eq (local.tee $squareVal (call $sqaure (local.get $squareNum))) (i64.const 0)) (then
          (return (i64.const 0))
        ))

        (local.set $sum (i64.add (local.get $sum) (local.get $squareVal)))

        (br_if 0 (i64.le_u 
          (local.tee $squareNum (i64.add (local.get $squareNum) (i64.const 1))) 
          (i64.const 64)
        ))
      )
    ))

    (local.get $sum)
  )
)
