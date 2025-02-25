(module
  (memory (export "mem") 1)

  ;;
  ;; Get the latest score from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the score board in linear memory
  ;; @param {i32} $inputLength - length of the score board in linear memory
  ;;
  ;; @result {i32} - latest score from the score board
  ;;
  (func (export "latest") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (i32.load (i32.sub (i32.add (local.get $inputOffset) (local.get $inputLength)) (i32.const 4)))
  )

  ;;
  ;; Get the highest score from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the score board in linear memory
  ;; @param {i32} $inputLength - length of the score board in linear memory
  ;;
  ;; @result {i32} - highest score from the score board
  ;;
  (func (export "personalBest") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (local $index i32)
    (local $next i32)
    (local $best i32)
    (loop $findBest
      (local.set $next (i32.load (i32.add (local.get $inputOffset) (local.get $index))))
      (if (i32.gt_u (local.get $next) (local.get $best)) (then (local.set $best (local.get $next))))
      (local.set $index (i32.add (local.get $index) (i32.const 4)))
    (br_if $findBest (i32.lt_u (local.get $index) (local.get $inputLength))))
    (local.get $best)
  )

  ;;
  ;; Get the three highest scores from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the score board in linear memory
  ;; @param {i32} $inputLength - length of the score board in linear memory
  ;;
  ;; @result {(i32,i32,i32)} - three highest score from the score board
  ;;
  (func (export "personalTopThree") (param $inputOffset i32) (param $inputLength i32) (result i32 i32 i32)
    (local $index i32)
    (local $next i32)
    (local $first i32)
    (local $second i32)
    (local $third i32)
    (loop $findTopThree
      (local.set $next (i32.load (i32.add (local.get $inputOffset) (local.get $index))))
      (if (i32.gt_u (local.get $next) (local.get $first)) (then
        (local.set $third (local.get $second))
        (local.set $second (local.get $first))
        (local.set $first (local.get $next)))
      (else (if (i32.gt_u (local.get $next) (local.get $second)) (then 
        (local.set $third (local.get $second))
        (local.set $second (local.get $next))) 
      (else (if (i32.gt_u (local.get $next) (local.get $third)) (then
        (local.set $third (local.get $next))))))))
      (local.set $index (i32.add (local.get $index) (i32.const 4)))
    (br_if $findTopThree (i32.lt_u (local.get $index) (local.get $inputLength))))
    (local.get $first) (local.get $second) (local.get $third)
  )
)