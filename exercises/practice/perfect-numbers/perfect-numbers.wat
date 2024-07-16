(module
  (global $nonPositive i32 (i32.const 0))
  (global $deficient i32 (i32.const 1))
  (global $perfect i32 (i32.const 2))
  (global $abundant i32 (i32.const 3))

  ;;
  ;; Determine if a number is perfect
  ;;
  ;; @param {i32} number - The number to check
  ;;
  ;; @returns {i32} 0 if non-positive, 1 if deficient, 2 if perfect, 3 if abundant
  ;;
  (func (export "classify") (param $number i32) (result i32)
    (global.get $perfect)
  )
)
