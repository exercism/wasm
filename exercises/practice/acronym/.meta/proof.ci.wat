(module
  (import "env" "linearMemory" (memory 1))

  (global $apostrophe i32 (i32.const 39))
  (global $A i32 (i32.const 65))
  (global $Z i32 (i32.const 90))
  (global $a i32 (i32.const 97))
  (global $z i32 (i32.const 122))

  ;; Distance between A and a
  (global $caseOffset i32 (i32.const 32))

  (func $isupper (param $charCode i32) (result i32)
    (i32.and
      (i32.ge_s (local.get $charCode) (global.get $A))
      (i32.le_s (local.get $charCode) (global.get $Z))
    )
  )

  (func $islower (param $charCode i32) (result i32)
    (i32.and
      (i32.ge_s (local.get $charCode) (global.get $a))
      (i32.le_s (local.get $charCode) (global.get $z))
    )
  )

  (func $isalpha (param $charCode i32) (result i32)
    (i32.or
      (call $islower (local.get $charCode))
      (call $isupper (local.get $charCode))
    )
  )

  (func $toupper (param $charCode i32) (result i32)
    (if (call $islower (local.get $charCode)) (then
      (return (i32.sub (local.get $charCode) (global.get $caseOffset)))
    ))

    (return (local.get $charCode))
  )

  ;; In-place transformation using two-pointer technique
  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32)
    (local $charCode i32)
    (local $resultLength i32)
    (local $isStartOfToken i32)
    (local.set $resultLength (i32.const 0))

    (if (i32.eqz (local.get $length)) (then 
      (return (local.get $offset) (local.get $length))
    ))

    (local.set $i (i32.const 0))
    (local.set $resultLength (i32.const 0))
    (local.set $isStartOfToken (i32.const 1))
    (loop
      (local.set $charCode (i32.load8_u (i32.add (local.get $offset) (local.get $i))))
      (if (i32.and 
        (i32.and 
          (i32.eqz (call $isalpha (local.get $charCode)))
          (i32.ne (local.get $charCode) (global.get $apostrophe))
        )
        (i32.eqz (local.get $isStartOfToken))
      ) (then
        (local.set $isStartOfToken (i32.const 1))
      ) (else
        (if (i32.and
          (local.get $isStartOfToken)
          (call $isalpha (local.get $charCode))
        ) (then
          (i32.store8 
            (i32.add (local.get $offset) (local.get $resultLength)) 
            (call $toupper (local.get $charCode))
          )
          (local.set $resultLength (i32.add (local.get $resultLength) (i32.const 1)))
          (local.set $isStartOfToken (i32.const 0))
        ))     
      ))
    
      (br_if 0 (i32.lt_s (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $length)))
    )

    (return (local.get $offset) (local.get $resultLength))
  )
)
