(module
  (memory (export "mem") 1)

  (data $prefix "One for ")
  (data $default "you")
  (data $suffix ", one for me.")
 
  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (local $resultOffset i32)
    (local $resultLength i32)
    (local $cursor i32)
    (local.set $resultOffset (i32.add (local.get $offset) (local.get $length)))
    (local.set $resultLength (i32.const 0))

    (memory.init $prefix (i32.add (local.get $resultOffset) (local.get $resultLength)) (i32.const 0) (i32.const 8))
    (local.set $resultLength (i32.add (local.get $resultLength) (i32.const 8)))

    (if (i32.gt_u (local.get $length) (i32.const 0)) (then
      (memory.copy (i32.add (local.get $resultOffset) (local.get $resultLength)) (local.get $offset) (local.get $length))
      (local.set $resultLength (i32.add (local.get $resultLength) (local.get $length)))
    ) (else 
      (memory.init $default (i32.add (local.get $resultOffset) (local.get $resultLength)) (i32.const 0) (i32.const 3))
      (local.set $resultLength (i32.add (local.get $resultLength) (i32.const 3)))
    ))

    (memory.init $suffix (i32.add (local.get $resultOffset) (local.get $resultLength)) (i32.const 0) (i32.const 13))
    (local.set $resultLength (i32.add (local.get $resultLength) (i32.const 13)))

    (return (local.get $resultOffset) (local.get $resultLength))
  )
)
