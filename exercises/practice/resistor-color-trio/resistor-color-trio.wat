(module
  (memory (export "mem") 1)

  ;;
  ;; Converts color codes, as used on resistors, to a string showing the value and unit.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;; @param {i32} thirdOffset - The offset of the third string in linear memory.
  ;; @param {i32} thirdLength - The length of the third string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the resistance specified 
  ;;                        by the color codes as a string in linear memory;
  ;;                        erroneous inputs receive an empty string
  ;;
  (func (export "value")
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32)
    (param $thirdOffset i32) (param $thirdLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
