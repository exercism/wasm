(module
  (memory (export "mem") 1)

  ;;
  ;; Find the points in the matrix that are the largest in row and smallest in column
  ;;
  ;; @param {i32} $inputOffset - offset of the matrix in linear memory
  ;; @param {i32} $inputLength - length of the matrix in linear memory
  ;;
  ;; @result {(i32,i32)} - offset and length of row-column-pairs in linear memory
  ;;
  (func (export "saddlePoints") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  ) 
)