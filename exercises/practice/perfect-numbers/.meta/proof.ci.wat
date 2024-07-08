(module

  ;;
  ;; Determine if a number is perfect
  ;;
  ;; @param {i32} number - The number to check
  ;;
  ;; @returns {i32} 0 if non-positive, 1 if deficient, 2 if perfect, 3 if abundant
  ;;
  (func (export "classify") (param $number i32) (result i32)
    (local $remaining i32)
    (local $p i32)
    (local $step i32)
    (local $factors i32)
    (local $total i32)

    (if (i32.le_s (local.get $number) (i32.const 1)) (then
      ;; The number 1 is deficient, while negative numbers and zero are non-positive.
      (return (i32.eq (local.get $number) (i32.const 1)))
    ))

    (local.set $remaining (local.get $number))
    (local.set $p (i32.const 2))
    (local.set $step (i32.const 1))
    (local.set $factors (i32.const 1))

    (loop $prime
      (if (i32.lt_u (local.get $remaining) (i32.mul (local.get $p) (local.get $p))) (then
        (local.set $p (local.get $remaining))
      ))

      (if (i32.eqz (i32.rem_u (local.get $remaining) (local.get $p))) (then
        (local.set $total (i32.add (local.get $p) (i32.const 1)))
        (local.set $remaining (i32.div_u (local.get $remaining) (local.get $p)))
        (loop $power
          (if (i32.eqz (i32.rem_u (local.get $remaining) (local.get $p))) (then
            (local.set $remaining (i32.div_u (local.get $remaining) (local.get $p)))
            (local.set $total (i32.add (i32.mul (local.get $total) (local.get $p)) (i32.const 1)))
            (br $power)
          ))
        )
        (local.set $factors (i32.mul (local.get $factors) (local.get $total)))
        (if (i32.eq (local.get $remaining) (i32.const 1)) (then
          (local.set $factors (i32.sub (local.get $factors) (local.get $number)))
          (if (i32.lt_u (local.get $factors) (local.get $number)) (then
            (return (i32.const 1))
          ) (else
            (return (i32.add (i32.const 2) (i32.gt_u (local.get $factors) (local.get $number))))
          ))
        ))
      ))

      (local.set $p (i32.add (local.get $p) (local.get $step)))
      (local.set $step (i32.const 2))
      (br $prime)
    )
    (unreachable)
  )
)
