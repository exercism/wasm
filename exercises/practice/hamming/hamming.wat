(module
    (import "env" "linearMemory" (memory 1))

    (func (export "compute") 
        (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
        (i32.const 42)
    )
)
