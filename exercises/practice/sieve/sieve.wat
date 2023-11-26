(module
  (memory (export "mem") 1)

  ;;
  ;; Determine all the prime numbers below a given limit.
  ;; Return the offset and length of the resulting array of primes.
  ;;
  ;; @param {i32} limit - the upper bound for the prime numbers
  ;;
  ;; @return {i32} - offset off the u32[] array
  ;; @return {i32} - length off the u32[] array in elements
  ;;
  (func (export "primes") (param $limit i32) (result i32 i32)
    (return (i32.const 12) (i32.const 13))
  )
)
