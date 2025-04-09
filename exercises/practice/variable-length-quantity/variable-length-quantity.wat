(module
  (memory (export "mem") 1)

  (global $incompleteSequence i32 (i32.const -1))

  ;;
  ;; Encode u32 values into u8 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u32 value array in linear memory
  ;; @param {i32} $inputLength - length of u32 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of u8 value array in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )

  ;;
  ;; Decode u8 values into u32 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u8 value array in linear memory
  ;; @param {i32} $inputLength - length of u8 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset or error code* and length of u32 value array in linear memory
  ;;                        *if the sequence is incomplete, use (global.get $incompleteSequence)
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
