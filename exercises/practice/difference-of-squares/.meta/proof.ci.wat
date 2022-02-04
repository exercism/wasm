(module
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (local $sum i32)
    (local $x i32)
    (local.set $sum (i32.const 0))
    (local.set $x (i32.const 1))
    
    ;; A break in a loop is actually like a "continue"
    ;; It jumps to the start of the loop. If no break is
    ;; encountered, control falls through the loop
    (if (i32.le_s (local.get $x) (local.get $max)) (then
      (loop
          (local.set $sum (i32.add (local.get $sum) (local.get $x)))
  
          (br_if 0 (i32.le_s
            ;; local.tee both updates a local and returns the result
            ;; Because we increment, this is like ++x
            (local.tee $x (i32.add (local.get $x) (i32.const 1)))
            (local.get $max)
          ))
      )
    ))

    (i32.mul (local.get $sum) (local.get $sum))
  )

  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
    (local $sum i32)
    (local $x i32)
    (local.set $sum (i32.const 0))
    (local.set $x (i32.const 1))
    
    ;; A break in a loop is actually like a "continue"
    ;; It jumps to the start of the loop. If no break is
    ;; encountered, control falls through the loop
    (if (i32.le_s (local.get $x) (local.get $max)) (then
      (loop
        (local.set $sum (i32.add 
          (local.get $sum) 
          (i32.mul (local.get $x) (local.get $x))
        ))

        ;; local.tee both updates a local and returns the result
        ;; Because we increment, this is like ++x
        (br_if 0 (i32.le_s
          (local.tee $x (i32.add (local.get $x) (i32.const 1)))
          (local.get $max)
        ))
      )
    ))

    (local.get $sum)
  )

  (func (export "difference") (param $max i32) (result i32)
    (i32.sub 
      (call $squareOfSum (local.get $max))
      (call $sumOfSquares (local.get $max))
    )
  )
)