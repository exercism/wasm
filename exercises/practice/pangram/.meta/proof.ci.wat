(module
  (import "env" "linearMemory" (memory 1))
  (import "env" "logInteger" (func $logInteger (param i32)))

  (global $lowerACharCode i32 (i32.const 97))
  (global $lowerZCharCode i32 (i32.const 122))
  (global $upperACharCode i32 (i32.const 65))
  (global $upperZCharCode i32 (i32.const 90))

  ;; 200 - 304
  (global $vecBaseOffset i32 (i32.const 200))
  (global $vecElemSize i32 (i32.const 4))
  (global $vecElemCapacity i32 (i32.const 26))

  (func $initLetterArray
    (memory.fill 
      (global.get $vecBaseOffset) 
      (i32.const 0) 
      (i32.mul (global.get $vecElemSize) (global.get $vecElemCapacity)))
  )

  ;; Increment char cound and return old count
  ;; Assumes that caller only passes lowercase
  (func $fetchAndAdd (param $charCode i32) (result i32)
    (local $offset i32)
    (local $count i32)

    (local.set $offset (i32.add 
      (global.get $vecBaseOffset) (i32.mul
        (global.get $vecElemSize)
        (i32.sub (local.get $charCode) (global.get $lowerACharCode))
      )
    ))

    (local.set $count (i32.load (local.get $offset)))
    (i32.store (local.get $offset) (i32.add (local.get $count) (i32.const 1)))
    (local.get $count)
  )

  ;; Returns 1 if all letter counts are 1, 0 otherwise
  (func $allNotZero (result i32)
    (local $i i32)
    (local $val i32)
    (local.set $i (i32.const 0))

    (loop
      (local.set $val (i32.load8_u (i32.add (global.get $vecBaseOffset) (i32.mul (global.get $vecElemSize) (local.get $i)))))

      ;; Return 0 if elem is zero
      (if (i32.eq (local.get $val) (i32.const 0)) (then (return (i32.const 0))))

      (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (i32.const 26)))
    )

    (i32.const 1)
  )


  ;; 1 if ASCII alphabetic char. 0 otherwise
  (func $isalpha (param $charCode i32) (result i32)
    (i32.or
      (i32.and
        (i32.ge_u (local.get $charCode) (global.get $lowerACharCode))
        (i32.le_u (local.get $charCode) (global.get $lowerZCharCode))
      )
      (i32.and
        (i32.ge_u (local.get $charCode) (global.get $upperACharCode))
        (i32.le_u (local.get $charCode) (global.get $upperZCharCode))
      )
    )
  )

  ;; Returns a lowercase char code if uppercase, original char code otherwise
  (func $tolower (param $charCode i32) (result i32)
    (if (i32.and
      (i32.ge_u (local.get $charCode) (global.get $upperACharCode))
      (i32.le_u (local.get $charCode) (global.get $upperZCharCode))
    ) (then 
      (return 
          (i32.add (local.get $charCode) (i32.const 32))
      )
    ) (else 
      (return (local.get $charCode))
    ))

    (unreachable)
  )

  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)

    (local $i i32 )
    (local $charCode i32)

    (local.set $i (i32.const 0))

    ;; No chance to be pangram if less than 26 characters!
    (if (i32.lt_u (local.get $length) (i32.const 26)) (then 
      (return (i32.const 0))
    )(else
      ;; Zero out array
      (call $initLetterArray)
      
      (loop
        (local.set $charCode (i32.load8_u (i32.add (local.get $offset) (local.get $i))))
        
        (if (call $isalpha (local.get $charCode)) (then
          (call $fetchAndAdd (call $tolower (local.get $charCode)))
          (drop)
        ))
        (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $length)))
      )
    ))

    ;; We need to confirm we saw each letter at least once
    (return (call $allNotZero))
  )
)
