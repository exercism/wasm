(module
  (memory (export "mem") 1)

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (return (local.get $textOffset) (local.get $textLength))
  )
)
