(module
  (memory (export "mem") 1)
  
  ;;
  ;; Count the rectangles in a grid with lines delimited by line breaks
  ;;
  ;; @param {i32} inputOffset - offset of the grid in linear memory
  ;; @param {i32} inputLength - length of the grid in linear memory
  ;;
  ;; @returns {i32} - number of rectangles in the grid
  ;;
  (func (export "count") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (i32.const 0)
  )
)