(module
  (memory (export "mem") 1)

  (func (export "countNucleotides") (param $offset i32) (param $length i32) (result i32 i32 i32 i32)
    (return 
      (i32.const -1)
      (i32.const -1)
      (i32.const -1)
      (i32.const -1)
    )
  )
)
