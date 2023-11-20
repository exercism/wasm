(module
  (memory (export "mem") 1)

  ;;
  ;; Converts a phrase into an acronym
  ;; i.e. "Ruby on Rails" -> "ROR"
  ;;
  ;; @param {i32} offset - offset of phrase in linear memory
  ;; @param {i32} length - length of phrase in linear memory
  ;;
  ;; @return {(i32, i32)} - offset and length of acronym
  ;;
  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    (return (local.get $offset) (local.get $length))
  )
)
