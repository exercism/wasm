(module
  (memory (export "mem") 1)

  (global $G i32 (i32.const 71))
  (global $C i32 (i32.const 67))
  (global $T i32 (i32.const 84))
  (global $A i32 (i32.const 65))
  (global $U i32 (i32.const 85))

  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32)
    (local $currentOffset i32)
    (local $currentValue i32)
    (local.set $i (i32.const 0))

    (if (i32.gt_u (local.get $length) (i32.const 0)) (then (loop
      (local.set $currentOffset (i32.add (local.get $offset) (local.get $i)))
      (local.set $currentValue (i32.load8_u (local.get $currentOffset)))
      ;; G -> C
      (if (i32.eq (local.get $currentValue) (global.get $G)) (then
        (i32.store8 (local.get $currentOffset) (global.get $C))
      ;; C -> G
      ) (else (if (i32.eq (local.get $currentValue) (global.get $C)) (then
        (i32.store8 (local.get $currentOffset) (global.get $G)) 
      ;; T -> A
      ) (else (if (i32.eq (local.get $currentValue) (global.get $T)) (then
        (i32.store8 (local.get $currentOffset) (global.get $A))
      ;; A -> U
      ) (else (if (i32.eq (local.get $currentValue) (global.get $A)) (then
        (i32.store8 (local.get $currentOffset) (global.get $U))
      ))))))))
      
      (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $length)))
    )))

    (return (local.get $offset) (local.get $length))
  )
)
