(module
  (memory (export "mem") 1)

  ;;
  ;; Lyrics to 'Ten Green Bottles'.
  ;;
  ;; @param {i32} startBottles - The initial number of bottles
  ;; @param {i32} takeDown - The number of bottles to be taken down
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startBottles i32) (param $takeDown i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
