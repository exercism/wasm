(module
  (import "env" "linearMemory" (memory 1))
 
  ;; Assumes size of i32
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (i32.const 42)
  )
)
