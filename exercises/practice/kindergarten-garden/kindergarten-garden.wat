(module
  (memory (export "mem") 1)

  ;;
  ;; Determine which plants a child in the kindergarten class is responsible for.
  ;;
  ;; @param {i32} diagramOffset - The offset of the diagram string in linear memory.
  ;; @param {i32} diagramLength - The length of the diagram string in linear memory.
  ;; @param {i32} studentOffset - The offset of the student string in linear memory.
  ;; @param {i32} studentLength - The length of the student string in linear memory.
  ;;
  ;; @returns {(i32,i32)} - Offset and length of plants string
  ;;                        in linear memory.
  ;;
  (func (export "plants")
    (param $diagramOffset i32) (param $diagramLength i32) (param $studentOffset i32) (param $studentLength i32) (result i32 i32)
    (return (i32.const 0) (i32.const 0))
  )
)
