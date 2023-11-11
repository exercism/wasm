(module
  (memory (export "mem") 1)
  
  ;; Status codes returned as res[2]
  (global $ok i32 (i32.const 0))
  (global $inputHasWrongFormat i32 (i32.const -1))
  (global $wrongInputBase i32 (i32.const -2))
  (global $wrongOutputBase i32 (i32.const -3))

  ;;
  ;; Convert an array of digits in inputBase to an array of digits in outputBase
  ;; @param {i32} arrOffset - base offset of input u32[] array                
  ;; @param {i32} arrLength - length of the input u32[] array in elements
  ;; @param {i32} inputBase - base of the input array
  ;; @param {i32} outputBase - base of the output array
  ;; @return {i32} - base offset of the output u32[] array
  ;; @return {i32} - length of the output u32[] array in elements                   
  ;; @return {i32} - status code (0, -1, -2, -3)                                
  ;;
  (func (export "convert") (param $arrOffset i32) (param $arrLength i32) (param $inputBase i32) (param $outputBase i32) (result i32 i32 i32)
    (return (local.get $arrOffset) (local.get $arrLength) (i32.const 42))
  )
)
