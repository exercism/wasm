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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0) (i32.const 0) (i32.const 0)
  )
)