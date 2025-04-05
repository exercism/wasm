(module
  (memory (export "mem") 1)

  ;;
  ;; Generate an array of u16 numbers that when put into a square 2d-array will result in a spiral matrix
  ;;
  ;; @param {i32} $size - length of the sides of the matrix
  ;;
  ;; @returns {(i32,i32)} - offset and length of the u16 number array
  ;;
  (func (export "spiralMatrix") (param $size i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)