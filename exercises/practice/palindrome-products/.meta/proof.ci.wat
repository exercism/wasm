(module
  (import "console" "log_i32_s" (func $log_i32_s (param i32)))
  (memory (export "mem") 1)

  (global $minMaxError i32 (i32.const -1))

  ;;
  ;; Find the first palindrome product based on factors inclusively between minFactor and maxFactor, iterating by step 
  ;;
  ;; @param {i32} $minFactor - smallest factor of the product
  ;; @param {i32} $maxFactor - largest factor of the product
  ;; @param {i32} $step - step 
  ;;
  ;; @returns {(i32,i32,i32)} - product (0 = not found, -1 = error), offset and length of an array of pairwise factors
  ;; 
  (func $find (param $minFactor i32) (param $maxFactor i32) (param $step i32) (result i32 i32 i32)
    (local $prod i32)
    (local $last i32)
    (local $factor i32)
    (local $cofactor i32)
    (local $num i32)
    (local $rev i32)
    (local $factorsCount i32)
    (if (i32.gt_u (local.get $minFactor) (local.get $maxFactor)) (then
      (return (global.get $minMaxError) (i32.const 0) (i32.const 0))))
    (if (i32.eq (local.get $step) (i32.const 1)) (then
      (local.set $prod (i32.sub (i32.mul (local.get $minFactor) (local.get $minFactor)) (i32.const 1)))
      (local.set $last (i32.mul (local.get $maxFactor) (local.get $maxFactor)))) 
    (else
      (local.set $prod (i32.sub (i32.mul (local.get $maxFactor) (local.get $maxFactor)) (i32.const -1)))
      (local.set $last (i32.mul (local.get $minFactor) (local.get $minFactor)))))
    (loop $products
      (local.set $prod (i32.add (local.get $prod) (local.get $step)))
      (local.set $num (local.get $prod))
      (local.set $rev (i32.const 0))
      (loop $reverse
        (local.set $rev (i32.add (i32.mul (local.get $rev) (i32.const 10))
          (i32.rem_s (local.get $num) (i32.const 10))))
        (local.set $num (i32.div_u (local.get $num) (i32.const 10)))
      (br_if $reverse (local.get $num)))
      (if (i32.eq (local.get $rev) (local.get $prod)) (then
        (local.set $factor (local.get $minFactor))
        (loop $factorize
          (if (i32.eqz (i32.rem_u (local.get $prod) (local.get $factor))) (then
            (local.set $cofactor (i32.div_u (local.get $prod) (local.get $factor)))
            (if (i32.lt_u (local.get $cofactor) (local.get $factor))
              (then (local.set $factor (local.get $maxFactor)))
              (else (if (i32.and (i32.ge_u (local.get $cofactor) (local.get $minFactor))
                (i32.le_u (local.get $cofactor) (local.get $maxFactor))) (then 
                  (i32.store (i32.shl (local.get $factorsCount) (i32.const 2)) (local.get $factor))
                  (i32.store (i32.shl (i32.add (local.get $factorsCount) (i32.const 1)) (i32.const 2))
                    (local.get $cofactor))
                  (local.set $factorsCount (i32.add (local.get $factorsCount) (i32.const 2)))))))))
                  (local.set $factor (i32.add (local.get $factor) (i32.const 1)))
        (br_if $factorize (i32.le_u (local.get $factor) (local.get $maxFactor))))
        (if (local.get $factorsCount) (then
          (return (local.get $prod) (i32.const 0) (local.get $factorsCount))))
      ))
    (br_if $products (i32.ne (local.get $prod) (local.get $last))))
    (i32.const 0) (i32.const 0) (i32.const 0)
  )

  ;;
  ;; Find the smallest palindrome product based on factors inclusively between minFactor and maxFactor
  ;;
  ;; @param {i32} $minFactor - smallest factor of the product
  ;; @param {i32} $maxFactor - largest factor of the product
  ;;
  ;; @returns {(i32,i32,i32)} - product (0 = not found, -1 = error), offset and length of an array of pairwise factors
  ;; 
  (func (export "smallest") (param $minFactor i32) (param $maxFactor i32) (result i32 i32 i32)
    (call $find (local.get $minFactor) (local.get $maxFactor) (i32.const 1))
  )

  ;;
  ;; Find the largest palindrome product based on factors inclusively between minFactor and maxFactor
  ;;
  ;; @param {i32} $minFactor - smallest factor of the product
  ;; @param {i32} $maxFactor - largest factor of the product
  ;;
  ;; @returns {(i32,i32,i32)} - product (0 = not found, -1 = error), offset and length of an array of pairwise factors
  ;; 
  (func (export "largest") (param $minFactor i32) (param $maxFactor i32) (result i32 i32 i32)
    (call $find (local.get $minFactor) (local.get $maxFactor) (i32.const -1))
  )
)
