(module
  (memory (export "mem") 1)

  ;;
  ;; Rewrite the incoming JSON to the new ETL format
  ;;
  ;; @param {i32} $inputOffset - offset of the JSON input in linear memory
  ;; @param {i32} $inputLength - length of the JSON input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the JSON output in linear memory
  ;;
  (func (export "transform") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)