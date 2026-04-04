(module
  (memory (export "mem") 1)

  ;;
  ;; Determine if the dominoes form a chain.
  ;;
  ;; Each domino is stored as two consecutive bytes in linear memory (left, right).
  ;;
  ;; @param {i32} offset - offset of domino array in linear memory
  ;; @param {i32} count  - number of dominoes
  ;;
  ;; @returns {i32} 1 if the dominoes form a chain, 0 otherwise
  ;;
  (func (export "canChain") (param $offset i32) (param $count i32) (result i32)
    (return (i32.const 1))
  )
)
