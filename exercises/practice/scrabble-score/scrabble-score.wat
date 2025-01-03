(module
  (memory (export "mem") 1)

  ;;
  ;; Given a word, compute the Scrabble score for that word
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {i32} - the computed score
  ;;
  (func (export "score") (param $offset i32) (param $len i32) (result i32)
    (return (i32.const -1))
  )
)
