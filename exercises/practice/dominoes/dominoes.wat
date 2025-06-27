(module
  (memory (export "mem") 1)

  ;;
  ;; Determine if the dominoes form a chain.
  ;;
  ;; @param {i32} offset - offset of byte array in linear memory
  ;; @param {i32} length - length of byte array in linear memory
  ;;
  ;; @returns {i32} 1 if the dominoes form a chain, 0 otherwise
  ;;
  (func (export "canChain") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
