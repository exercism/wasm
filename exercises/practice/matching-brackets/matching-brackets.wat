(module
  (memory (export "mem") 1)

  ;; Determines of the brackets in a string is balanced.
  ;;
  ;; @param {i32} text - the offset where the text string begins in memory
  ;; @param {i32} length - the length of the text
  ;;
  ;; @returns {i32} 1 if brackets are in pairs, 0 otherwise
  ;;
  (func (export "isPaired") (param $text i32) (param $length i32) (result i32)
    ;; Please implement the isPaired function.
    (return (i32.const 0))
  )
)
