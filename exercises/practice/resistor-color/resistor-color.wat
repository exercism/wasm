(module
  (memory (export "mem") 1)

  (data (i32.const 100) "black")

  ;;
  ;; Return buffer of comma separated colors
  ;; "black,brown,red,orange,yellow,green,blue,violet,grey,white"
  ;;
  ;; @returns {(i32, i32)} - The offset and length of the buffer of comma separated colors
  ;;
  (func (export "colors") (result i32 i32)
    (return (i32.const 100) (i32.const 5))
  )

  ;;
  ;; Initialization function called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  ;; Can be deleted if not needed
  ;;
  (func $initialize)
  (start $initialize)

  ;;
  ;; Given a valid resistor color, returns the associated value
  ;;
  ;; @param {i32} offset - offset into the color buffer
  ;; @param {i32} len - length of the color string
  ;;
  ;; @returns {i32} - the associated value
  ;;
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (return (i32.const -1))
  )
)
