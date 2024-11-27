(module
  (memory (export "mem") 1)

  ;;
  ;; Create the next frame of Conway's Game of Life
  ;;
  ;; @param {i32} offset - The offset of the current frame in linear memory
  ;; @param {i32} length - The length of the current frame in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the next frame in linear memory
  ;;
  (func (export "next") (param $offset i32) (param $cols i32) (param $rows i32) (result i32)
    (return (local.get $offset))
  )
)
