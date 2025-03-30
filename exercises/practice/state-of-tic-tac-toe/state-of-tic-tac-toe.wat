(module
  (memory (export "mem") 1)

  ;; valid states
  (global $ongoing i32 (i32.const 0))
  (global $draw i32 (i32.const 1))
  (global $win i32 (i32.const 2))
  ;; invalid states
  (global $xtwice i32 (i32.const -1))
  (global $ostarted i32 (i32.const -2))
  (global $movedafterwon i32 (i32.const -3))

  ;;
  ;; Get the state of a Tic-Tac-Toe field
  ;;
  ;; @param {i32} $inputOffset
  ;; @param {i32} $inputLength
  ;;
  ;; @returns {i32} - state (see globals for valid/invalid states)
  ;;
  (func (export "gamestate") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (global.get $win)
  )
)