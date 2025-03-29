(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 0))
  ;;
  ;; Calculate the prime factors of the number
  ;;
  ;; @param {i64} $number
  ;;
  ;; @returns {(i32,i32)} - offset and length of the u64 array of prime factors
  ;;
  (func (export "primeFactors") (param $number i64) (result i32 i32)
    (local $factor i64)
    (local $outputLength i32)
    (if (i64.lt_s (local.get $number) (i64.const 2)) (then
      (return (global.get $outputOffset) (i32.const 0))))
    (local.set $factor (i64.const 2))
    (loop $factorize
      (if (i64.eqz (i64.rem_u (local.get $number) (local.get $factor))) (then
        (i64.store (i32.add (global.get $outputOffset)
          (i32.shl (local.get $outputLength) (i32.const 2))) (local.get $factor))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $number (i64.div_u (local.get $number) (local.get $factor))))
      (else (local.set $factor (i64.add (local.get $factor) (i64.const 1)))))
    (br_if $factorize (i64.le_s (local.get $factor) (local.get $number))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)