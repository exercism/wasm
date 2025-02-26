(module
  (memory (export "mem") 1)

  ;;
  ;; Output pythagorean triplets for sum, minfactor and maxfactor
  ;;
  ;; @param {i32} $sum - sum of the triplets
  ;; @param {i32} $minFactor - smallest allowed factor
  ;; @param {i32} $maxFactor - largest allowed factor
  ;;
  ;; @returns {(i32.i32)} - offset and length of all triplets without delimiter as i32 numbers
  ;;
  (func (export "triplets") (param $sum i32) (param $minFactor i32) (param $maxFactor i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)