(module
  (memory (export "mem") 1)

  ;;
  ;; Lyrics to 'The Twelve Days of Christmas'.
  ;;
  ;; @param {i32} startVerse - The initial verse to recite
  ;; @param {i32} endVerse - The final verse to recite
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startVerse i32) (param $endVerse i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
