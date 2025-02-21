(module
  (memory 1)

  ;; 8 * f64 orbital periods
  (data (i32.const 0) "\2d\bd\ec\8d\10\d4\ce\3f\ec\3d\09\2a\b2\af\e3\3f\00\00\00\00\00\00\f0\3f\1d\cd\ec\4e\d2\17\fe\3f\fd\13\5c\ac\a8\b9\27\40\81\06\9b\3a\8f\72\3d\40\61\c4\3e\01\14\01\55\40\77\15\52\7e\52\99\64\40")

  (global (export "mercury") i32 (i32.const 0))
  (global (export "venus") i32 (i32.const 1))
  (global (export "earth") i32 (i32.const 2))
  (global (export "mars") i32 (i32.const 3))
  (global (export "jupiter") i32 (i32.const 4))
  (global (export "saturn") i32 (i32.const 5))
  (global (export "uranus") i32 (i32.const 6))
  (global (export "neptune") i32 (i32.const 7))

  (global $secondsPerYearHundredth f64 (f64.const 315576.0))

  ;;
  ;; calculates the age in planetary years based on planet and number of seconds
  ;;
  ;; @param {i32} $planet - 0-7, see exported planets
  ;; @param {i32} $seconds - number of seconds
  ;;
  ;; @result {f64} age in years on the planet
  ;;
  (func (export "age") (param $planet i32) (param $seconds i32) (result f64)
    (local $orbitalPeriod f64)
    (local.set $orbitalPeriod (f64.load (i32.shl (local.get $planet) (i32.const 3))))
    (f64.div (f64.nearest (f64.div (f64.div (f64.convert_i32_u (local.get $seconds))
      (local.get $orbitalPeriod)) (global.get $secondsPerYearHundredth))) (f64.const 100))
  )  
)
