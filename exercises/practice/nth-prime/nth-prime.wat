(module
  ;;
  ;; nth_prime - return the nth prime for n > 0
  ;;
  ;; @param {i32} $n - index of the returned prime
  ;;
  ;; @returns {i32} - the $nth prime
  ;;
  (func (export "prime") (param $n i32) (result i32)
    (i32.const 2)
  )
)
