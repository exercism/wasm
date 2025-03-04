(module
  (memory (export "mem") 1)
  
  (global $unequal i32 (i32.const 0))
  (global $sublist i32 (i32.const 1))
  (global $equal i32 (i32.const 2))
  (global $superlist i32 (i32.const 3))

  ;;
  ;; Compare two lists.
  ;;
  ;; @param {i32} $firstOffset - offset of the first list in linear memory
  ;; @param {i32} $firstLength - length of the first list in linear memory
  ;; @param {i32} $secondOffset - offset of the second list in linear memory
  ;; @param {i32} $secondLength - length of the second list in linear memory
  ;;
  ;; @returns {i32} - $unequal, $sublist, $equal or $superlist
  ;;
  (func (export "compare") (param $firstOffset i32) (param $firstLength i32)
    (param $secondOffset i32) (param $secondLength i32) (result i32)
    (global.get $equal)
  )
)