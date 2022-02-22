
(module
  (memory (export "mem") 1)

  ;; ASCII / UTF-7 / UTF-8 char codes
  (global $A i32 (i32.const 65))
  (global $C i32 (i32.const 67))
  (global $G i32 (i32.const 71))
  (global $T i32 (i32.const 84))

  (func (export "countNucleotides") (param $offset i32) (param $length i32) (result i32 i32 i32 i32)
    (local $adenineCount i32)
    (local $cytosineCount i32)
    (local $guanineCount i32)
    (local $thymineCount i32)
    (local $i i32)
    (local $charCode i32)
    (local.set $adenineCount (i32.const 0))
    (local.set $cytosineCount (i32.const 0))
    (local.set $guanineCount (i32.const 0))
    (local.set $thymineCount (i32.const 0))

    (local.set $i (i32.const 0))
    (if (i32.gt_u (local.get $length) (i32.const 0)) (then (loop
      (local.set $charCode (i32.load8_u (i32.add (local.get $offset) (local.get $i))))
      (if (i32.eq (local.get $charCode) (global.get $A)) (then
        (local.set $adenineCount (i32.add (local.get $adenineCount) (i32.const 1)))
      ) (else (if (i32.eq (local.get $charCode) (global.get $C)) (then
        (local.set $cytosineCount (i32.add (local.get $cytosineCount) (i32.const 1)))
      ) (else (if (i32.eq (local.get $charCode) (global.get $G)) (then
        (local.set $guanineCount (i32.add (local.get $guanineCount) (i32.const 1)))
      ) (else (if (i32.eq (local.get $charCode) (global.get $T)) (then
        (local.set $thymineCount (i32.add (local.get $thymineCount) (i32.const 1)))
      ) (else 
          (return 
            (i32.const -1)
            (i32.const -1)
            (i32.const -1)
            (i32.const -1)
          )
      ))))))))
    
      (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $length)))
    )))

    (local.get $adenineCount)
    (local.get $cytosineCount)
    (local.get $guanineCount)
    (local.get $thymineCount)
  )

)
