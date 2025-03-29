(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the prime factors of the number
  ;;
  ;; @param {i64} $number
  ;;
  ;; @returns {(i32,i32)} - offset and length of the u32 array of prime factors
  ;;
  (func (export "primeFactors") (param $number i64) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)