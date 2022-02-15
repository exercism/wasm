(module
  (import "env" "linearMemory" (memory 1))
  
  ;; Status codes returned as res[2]
  (global $ok i32 (i32.const 0))
  (global $inputHasWrongFormat i32 (i32.const -1))
  (global $wrongInputBase i32 (i32.const -2))
  (global $wrongOutputBase i32 (i32.const -3))

  ;; Returns offset and length of resulting u32[] and a return status code
  (func (export "convert") (param $arrOffset i32) (param $arrLength i32) (param $inputBase i32) (param $outputBase i32) (result i32 i32 i32)
    (return (local.get $arrOffset) (local.get $arrLength) (i32.const 42))
  )
)
