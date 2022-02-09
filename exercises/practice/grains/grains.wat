(module
  ;; Result is unsigned
  (func $sqaure (export "square") (param $squareNum i64) (result i64)
    (i64.const 42)
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (i64.const 42)
  )
)
