(module
  (memory (export "mem") 1)

  ;;
  ;; Tally the tournament results into a formatted table
  ;;
  ;; @param {i32} $inputOffset - offset of the tournament results in linear memory
  ;; @param {i32} $inputLength - length of the tournament results in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the formatted tally in linear memory
  ;;
  (func (export "tournamentTally") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)