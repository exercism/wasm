(module
  (memory (export "mem") 1)

  (func $maximumValue (param $itemsOffset i32) (param $itemsCount i32) (param $capacity i32) (result i32)
    (local $itemWeight i32)
    (local $itemValue i32)
    (local $valueWith i32)
    (local $valueWithout i32)

    (if
      (i32.eq
        (local.get $itemsCount)
        (i32.const 0))
      (then (return (i32.const 0)))
    )

    (local.set $itemWeight (i32.load (local.get $itemsOffset)))

    (local.set $valueWithout
      (call 
        $maximumValue
        (i32.add
          (local.get $itemsOffset)
          (i32.const 8)
        )
        (i32.sub
          (local.get $itemsCount)
          (i32.const 1)
        )
        (local.get $capacity)
      )
    )

    (if 
      (i32.lt_u
        (local.get $capacity)
        (local.get $itemWeight)
      )
      (then
        (return 
          (local.get $valueWithout)
        )
      )
    )
  
    (local.set $itemValue 
      (i32.load 
        (i32.add 
          (local.get $itemsOffset) 
          (i32.const 4)
        )
      )
    )
    (local.set $valueWith
      (i32.add
        (local.get $itemValue)
        (call
          $maximumValue
                  (i32.add
          (local.get $itemsOffset)
          (i32.const 8))
        (i32.sub
          (local.get $itemsCount)
          (i32.const 1))
        (i32.sub
          (local.get $capacity)
          (local.get $itemWeight))
        )
      )
    )
    
    (if
      (i32.gt_u
        (local.get $valueWith)
        (local.get $valueWithout))
      (then
        (return (local.get $valueWith))
      )
    )

    (return (local.get $valueWithout))
  )

  ;; Determine the maximum total value that can be carried
  ;;
  ;; @param {i32} itemsCount - The number of items
  ;; @param {i32} capacity - How much weight the knapsack can carry
  ;; @returns {i32} the maximum value
  ;;
  (func (export "maximumValue") (param $itemsCount i32) (param $capacity i32) (result i32)
    (return (call $maximumValue (i32.const 0) (local.get $itemsCount) (local.get $capacity)))
  )
)