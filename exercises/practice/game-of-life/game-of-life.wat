(module
  (memory (export "mem") 1)

  ;;
  ;; Create the next frame of Conway's Game of Life
  ;;
  ;; @param {i32} offset - The offset of the current frame in linear memory
  ;; @param {i32} cols - The number of columns in the frame
  ;; @param {i32} rows - The number of rows in the frame
  ;;
  ;; @returns {i32} - The offset of the next frame in linear memory
  ;;
  (func (export "next") (param $offset i32) (param $cols i32) (param $rows i32) (result i32)
    (return (local.get $offset))
  )
)
