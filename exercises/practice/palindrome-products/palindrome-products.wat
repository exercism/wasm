(module
  (memory (export "mem") 1)

  ;;
  ;; Find the smallest palindrome product based on factors inclusively between minFactor and maxFactor
  ;;
  ;; @param {i32} $minFactor - smallest factor of the product
  ;; @param {i32} $maxFactor - largest factor of the product
  ;;
  ;; @returns {(i32,i32,i32)} - product (0 = not found, -1 = error), offset and length of an array of pairwise factors
  ;; 
  (func (export "smallest") (param $minFactor i32) (param $maxFactor i32) (result i32 i32 i32)
    (i32.const 0) (i32.const 0) (i32.const 0)
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
    (i32.const 0) (i32.const 0) (i32.const 0)
  )
)
