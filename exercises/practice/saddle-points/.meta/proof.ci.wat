(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 1280))
  (global $parsedOffset i32 (i32.const 512))
  (global $rowMaxOffset i32 (i32.const 768))
  (global $colMinOffset i32 (i32.const 1024))
  (global $zero i32 (i32.const 48))
  (global $br i32 (i32.const 10))

  ;;
  ;; Find the points in the matrix that are the largest in row and smallest in column
  ;;
  ;; @param {i32} $inputOffset - offset of the matrix in linear memory
  ;; @param {i32} $inputLength - length of the matrix in linear memory
  ;;
  ;; @result {(i32,i32)} - offset and length of row-column-pairs in linear memory
  ;;
  (func (export "saddlePoints") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $row i32)
    (local $column i32)
    (local $lineLength i32)
    (local $rowsLength i32)
    (local $char i32)
    (local $pos i32)
    (local $height i32)
    (local $outputLength i32)
    (if (i32.eqz (local.get $inputLength)) (then (return (global.get $outputOffset) (i32.const 0))))
    (loop $scanInput
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $pos))))
      (if (i32.ge_u (local.get $char) (global.get $zero))
      (then (local.set $height (i32.add (i32.mul (local.get $height) (i32.const 10))
        (i32.sub (local.get $char) (global.get $zero)))))
      (else (i32.store8 (i32.add (global.get $parsedOffset) (local.get $outputLength)) (local.get $height))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1))
        (if (i32.gt_u (local.get $height) (i32.load8_u (i32.add (global.get $rowMaxOffset) (local.get $row))))
          (then (i32.store8 (i32.add (global.get $rowMaxOffset) (local.get $row)) (local.get $height))))
        (if (i32.le_u (local.get $height) (i32.sub (i32.load8_u (i32.add (global.get $colMinOffset)
          (local.get $column))) (i32.const 1)))
          (then (i32.store8 (i32.add (global.get $colMinOffset) (local.get $column)) (local.get $height))))
        (local.set $column (i32.add (local.get $column) (i32.const 1)))
        (local.set $height (i32.const 0)))))
      (if (i32.eq (local.get $char) (global.get $br)) (then
        (if (i32.eqz (local.get $lineLength)) (then (local.set $lineLength (local.get $pos))))
        (local.set $row (i32.add (local.get $row) (i32.const 1))
        (local.set $column (i32.const 0)))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $scanInput (i32.le_u (local.get $pos) (local.get $inputLength))))
    (local.set $rowsLength (i32.add (local.get $row) (i32.const 1)))
    (local.set $lineLength (i32.div_u (local.get $outputLength) (local.get $rowsLength)))
    (local.set $outputLength (i32.const 0))
    (local.set $row (i32.const 0))
    (loop $rows
      (local.set $column (i32.const 0))
      (loop $columns
        (local.set $height (i32.load8_u (i32.add (global.get $parsedOffset)
          (i32.add (i32.mul (local.get $row) (local.get $lineLength)) (local.get $column)))))
        (if (i32.and (i32.eq (local.get $height)
          (i32.load8_u (i32.add (global.get $rowMaxOffset) (local.get $row))))
          (i32.eq (local.get $height) (i32.load8_u (i32.add (global.get $colMinOffset) (local.get $column)))))
          (then (i32.store16 (i32.add (global.get $outputOffset) (local.get $outputLength))
              (i32.or (i32.shl (i32.add (local.get $column) (i32.const 1)) (i32.const 8))
                (i32.add (local.get $row) (i32.const 1))))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 2)))))
        (local.set $column (i32.add (local.get $column) (i32.const 1)))
      (br_if $columns (i32.lt_u (local.get $column) (local.get $lineLength))))
      (local.set $row (i32.add (local.get $row) (i32.const 1)))
    (br_if $rows (i32.lt_u (local.get $row) (local.get $rowsLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)
