(module
  (memory (export "mem") 1)

  ;;
  ;; Convert a string of DNA to RNA
  ;;
  ;; @param {i32} offset - The offset of the DNA string in linear memory
  ;; @param {i32} length - The length of the DNA string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the RNA string in linear memory
  ;;
  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (return (local.get $offset) (local.get $length))
  )
)
