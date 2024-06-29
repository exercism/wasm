(module
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