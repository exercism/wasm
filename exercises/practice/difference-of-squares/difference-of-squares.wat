(module
  ;; The name prefixed with $ is used to internally refer to functions via the call instruction
  ;; The string in the export instruction is the name of the export made available to the
  ;; embedding environment (in this case, Node.js). This is used by our test runner Jest.
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (i32.const 42)
  )

  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
    (i32.const 42)
  )

  (func (export "difference") (param $max i32) (result i32)
    (call $squareOfSum (i32.const 42))
  )
)
