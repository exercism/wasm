(module
  ;; status codes
  (global $ok i32 (i32.const 0))
  (global $negativeRoll i32 (i32.const -1))
  (global $exceedingPinCount i32 (i32.const -2))
  (global $rollAfterEnd i32 (i32.const -3))
  (global $prematureScoring i32 (i32.const -4))

  ;; empty stack
  (global $empty i32 (i32.const -1))

  ;; game data
  (global $score (mut i32) (i32.const 0))
  (global $frame (mut i32) (i32.const 0))
  (global $stackA (mut i32) (i32.const -1))
  (global $stackB (mut i32) (i32.const -1))

  ;;
  ;; Collect a roll
  ;;
  ;; @param {i32} points - the points scored by a single roll
  ;;
  ;; @result {i32} - status code (see globals)
  ;;
  (func (export "roll") (param $points i32) (result i32)
    (if (i32.ge_u (global.get $frame) (i32.const 10)) (then (return (global.get $rollAfterEnd))))
    (if (i32.lt_s (local.get $points) (i32.const 0)) (then (return (global.get $negativeRoll))))
    ;; points > 10
    (if (i32.or (i32.gt_s (local.get $points) (i32.const 10)) (i32.or
      ;; stackA < 10, stackB = empty, stackA + points > 10
      (i32.and (i32.and (i32.ne (global.get $stackA) (i32.const 10))
        (i32.eq (global.get $stackB) (global.get $empty)))
        (i32.gt_s (i32.add (global.get $stackA) (local.get $points)) (i32.const 10)))
      ;; stackA = 10, stackB = 0..9, stackB + points > 10
      (i32.and (i32.and (i32.eq (global.get $stackA) (i32.const 10))
        (i32.and (i32.ne (global.get $stackB) (global.get $empty)) (i32.ne (global.get $stackB) (i32.const 10))))
        (i32.gt_s (i32.add (global.get $stackB) (local.get $points)) (i32.const 10)))))
      (then (return (global.get $exceedingPinCount))))
    ;; 2 in stack + 1 roll
    (if (i32.ne (global.get $stackB) (global.get $empty)) (then
      (global.set $score (i32.add (i32.add (i32.add (global.get $score) (global.get $stackA)) 
        (global.get $stackB)) (local.get $points)))
      (global.set $frame (i32.add (global.get $frame) (i32.const 1)))
      (if (i32.eq (global.get $stackA) (i32.const 10)) (then
        (global.set $stackA (global.get $stackB))
        (global.set $stackB (local.get $points)))
      (else 
        (global.set $stackA (local.get $points))
        (global.set $stackB (global.get $empty)))))
    ;; 1 in stack + 1 roll, being a spare
    (else (if (i32.and (i32.ne (global.get $stackA) (global.get $empty))
      (i32.lt_u (i32.add (global.get $stackA) (local.get $points)) (i32.const 10))) (then
      (global.set $score (i32.add (i32.add (global.get $score) (global.get $stackA)) (local.get $points)))
      (global.set $frame (i32.add (global.get $frame) (i32.const 1)))
      (global.set $stackA (global.get $empty))
      (global.set $stackB (global.get $empty)))
    ;; otherwise push to stack
    (else 
      (if (i32.eq (global.get $stackA) (global.get $empty))
        (then (global.set $stackA (local.get $points)))
      (else (global.set $stackB (local.get $points))))
    ))))
    (global.get $ok)
  )

  ;;
  ;; Score the game
  ;;
  ;; @result {i32} - points or status code (see globals)
  ;;
  (func (export "score") (result i32)
    (select (global.get $score)
      (global.get $prematureScoring)
      (i32.eq (global.get $frame) (i32.const 10)))
  )
)