(module
  ;;
  ;; nth_prime - return the nth prime for n > 0
  ;;
  ;; @param {i32} $n - index of the returned prime
  ;;
  ;; @returns {i32} - the $nth prime
  ;;
  (func (export "prime") (param $n i32) (result i32)
    (local $candidate i32)
    (local $factor i32)
    (if (i32.lt_s (local.get $n) (i32.const 1)) (then (return (i32.const -1))))
    (loop $count_up
      (local.set $candidate (i32.add (local.get $candidate) (i32.const 1)))
      (local.set $factor (i32.const 1))
      (loop $is_prime
        (local.set $factor (i32.add (local.get $factor) (i32.const 1)))
      (br_if $is_prime (i32.and (i32.lt_u (local.get $factor) (local.get $candidate))
        (i32.ne (i32.rem_u (local.get $candidate) (local.get $factor)) (i32.const 0)))))
      (if (i32.eq (local.get $candidate) (local.get $factor))
        (then (local.set $n (i32.sub (local.get $n) (i32.const 1)))))
    (br_if $count_up (local.get $n)))
    (local.get $candidate)
  )
)
