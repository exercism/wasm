(module
  ;; status codes
  (global $ok i32 (i32.const 0))
  (global $negativeRoll i32 (i32.const -1))
  (global $exceedingPinCount i32 (i32.const -2))
  (global $rollAfterEnd i32 (i32.const -3))
  (global $prematureScoring i32 (i32.const -4))

  ;;
  ;; Collect a roll
  ;;
  ;; @param {i32} points - the points scored by a single roll
  ;;
  ;; @result {i32} - status code (see globals)
  ;;
  (func (export "roll") (param $points i32) (result i32)
    (global.get $ok)
  )

  ;;
  ;; Score the game
  ;;
  ;; @result {i32} - points or status code (see globals)
  ;;
  (func (export "score") (result i32)
    (global.get $ok)
  )
)