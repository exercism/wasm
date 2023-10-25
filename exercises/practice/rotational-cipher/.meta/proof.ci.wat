(module
  (memory (export "mem") 1)

  (global $A i32 (i32.const 65))
  (global $Z i32 (i32.const 90))
  (global $a i32 (i32.const 97))
  (global $z i32 (i32.const 122))

  (func $wrap (param $low i32) (param $high i32) (param $value i32) (param $shiftKey i32) (result i32)
      (local $newValue i32)
      (local.set $newValue (local.get $value))
      
      (if 
        (i32.ge_u 
          (local.get $value) 
          (local.get $low)
        )
        (then 
          (if 
            (i32.le_u 
              (local.get $value) 
              (local.get $high)
            )
            (then
              ;; shift the value
              (local.set
                $newValue
                (i32.add 
                  (local.get $value)
                  (local.get $shiftKey)
                )
              )
                  
              ;; wrap when value greater than $high
              (if (i32.gt_u (local.get $newValue) (local.get $high))
                (then
                  (local.set $newValue
                    (i32.sub
                      (local.get $newValue)
                      (i32.const 26)
                    )
                  )
                )
              )
            )
          ) 
        )
      )

      (return (local.get $newValue))
  )

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    
    (local $index i32)
    (local $stop i32)
    (local $value i32)
    
    (local.set $index (local.get $textOffset))
    (local.set $stop 
      (i32.add 
        (local.get $textOffset)
        (local.get $textLength)
      )
    )

    (loop $process
      ;; shift upper case
      (local.set $value
        (call $wrap 
          (global.get $A)
          (global.get $Z)
          (i32.load8_u (local.get $index))
          (local.get $shiftKey)
        )
      )

      ;; shift lower case
      (local.set $value
        (call $wrap 
          (global.get $a)
          (global.get $z)
          (local.get $value)
          (local.get $shiftKey)
        )
      )

       (i32.store8
        (local.get $index)
        (local.get $value)
      )

      (local.set $index
        (i32.add (local.get $index) (i32.const 1))
      )

      (br_if
        $process
        (i32.lt_u (local.get $index) (local.get $stop)) 
      )
    )

    (return (local.get $textOffset) (local.get $textLength))
  )
)
