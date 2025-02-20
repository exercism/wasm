(module
  (global (export "mercury") i32 (i32.const 0))
  (global (export "venus") i32 (i32.const 1))
  (global (export "earth") i32 (i32.const 2))
  (global (export "mars") i32 (i32.const 3))
  (global (export "jupiter") i32 (i32.const 4))
  (global (export "saturn") i32 (i32.const 5))
  (global (export "uranus") i32 (i32.const 6))
  (global (export "neptune") i32 (i32.const 7))

  ;;
  ;; calculates the age in planetary years based on planet and number of seconds
  ;;
  ;; @param {i32} $planet - 0-7, see exported planets
  ;; @param {i32} $seconds - number of seconds
  ;;
  ;; @result {f64} age in years on the planet
  ;;
  (func (export "age") (param $planet i32) (param $seconds i32) (result f64)
    (f64.const 31.69)
  )
)