(module
  (memory (export "mem") 1)

  ;; return 1 if pangram, 0 otherwise
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    (return (i32.const 1))
  )
)
