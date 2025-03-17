(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 0))

  ;;
  ;; Output pythagorean triplets for sum, minfactor and maxfactor
  ;;
  ;; @param {i32} $sum - sum of the triplets
  ;;
  ;; @returns {(i32.i32)} - offset and length of all triplets without delimiter as i32 numbers
  ;;
  (func (export "triplets") (param $sum i32) (result i32 i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $maxFactor i32)
    (local $outputLength i32)
    (local.set $a (i32.const 1))
    (local.set $maxFactor (i32.shr_u (local.get $sum) (i32.const 1)))
    (loop $_a
      (local.set $b (i32.add (local.get $a) (i32.const 1)))
      (loop $_b
        (local.set $c (i32.sub (local.get $sum) (i32.add (local.get $a) (local.get $b))))
        (if (i32.lt_s (local.get $c) (i32.const 1)) (then (local.set $b (local.get $maxFactor))) (else 
          (if (i32.and (i32.lt_s (local.get $c) (local.get $maxFactor)) 
            (i32.eq (i32.add (i32.mul (local.get $a) (local.get $a))
              (i32.mul (local.get $b) (local.get $b)))
              (i32.mul (local.get $c) (local.get $c)))) (then
                (i32.store (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $a))
                (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 4)))
                (i32.store (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $b))
                (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 4)))
                (i32.store (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $c))
                (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 4)))))
        ))
        (local.set $b (i32.add (local.get $b) (i32.const 1)))
      (br_if $_b (i32.le_u (local.get $b) (local.get $maxFactor))))
      (local.set $a (i32.add (local.get $a) (i32.const 1)))
    (br_if $_a (i32.le_u (local.get $a) (local.get $maxFactor))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)