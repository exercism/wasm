(module
  (memory (export "mem") 1)
  
  (global $outputOffset i32 (i32.const 0))

  ;;
  ;; Provide the numbers for Pascals triangle with a given number of rows
  ;;
  ;; @param {i32} $count - number of rows
  ;;
  ;; @returns {(i32,i32)} - offset and count of the numbers stored as i32 in linear memory
  ;;
  (func (export "rows") (param $count i32) (result i32 i32)
    (local $row i32)
    (local $column i32)
    (local $number i32)
    (local $outputLength i32)
    (if (i32.eqz (local.get $count)) (then
      (return (global.get $outputOffset) (i32.const 0))))
    (local.set $row (i32.const 1))
    (loop $rows
      (local.set $column (i32.const 1))
      (loop $columns
        (local.set $number (i32.const 1))
        (if (i32.and (i32.gt_u (local.get $row) (i32.const 2))
          (i32.and (i32.ne (local.get $column) (i32.const 1))
          (i32.ne (local.get $column) (local.get $row))))
        (then (local.set $number (i32.add
          (i32.load (i32.add (global.get $outputOffset) 
            (i32.sub (local.get $outputLength) (i32.shl (local.get $row) (i32.const 2))))) 
          (i32.load (i32.add (global.get $outputOffset) (i32.sub (local.get $outputLength)
            (i32.shl (i32.sub (local.get $row) (i32.const 1)) (i32.const 2)))))))))
        (i32.store (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $number))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 4)))
        (local.set $column (i32.add (local.get $column) (i32.const 1)))
      (br_if $columns (i32.le_u (local.get $column) (local.get $row))))
      (local.set $row (i32.add (local.get $row) (i32.const 1)))
    (br_if $rows (i32.le_u (local.get $row) (local.get $count))))
    (global.get $outputOffset) (i32.shr_u (local.get $outputLength) (i32.const 2))
  )
)