(module
  (memory (export "mem") 1)

  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (return (i32.const 8) (i32.const 0))
  )
)
