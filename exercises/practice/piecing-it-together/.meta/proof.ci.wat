(module
  ;; formats
  (global $landscape (export "landscape") i32 (i32.const 1))
  (global $square (export "square") i32 (i32.const 2))
  (global $portrait (export "portrait") i32 (i32.const 3))
  ;; errors
  (global $INSUFFICIENT (export "INSUFFICIENT") i32 (i32.const -2))
  (global $CONTRADICTORY (export "CONTRADICTORY") i32 (i32.const -3))

  ;;
  ;; findColumns - find the columns for puzzles based on pieces, border pieces and format
  ;;
  ;; @param {i32} $pieces - total number of pieces
  ;; @param {i32} $border - number of border pieces
  ;; @param {i32} $format - see formats globals
  ;;
  ;; @returns {i32} number of columns
  ;;
  (func $findColumns (param $pieces i32) (param $border i32) (param $format i32) (result i32)
    (local $c i32)
    (local.set $c (i32.trunc_f64_u (f64.ceil (f64.sqrt (f64.convert_i32_u (local.get $pieces))))))
    (loop $find
      (local.set $c (i32.sub (local.get $c) (i32.const 1)))
    (br_if $find (i32.and (i32.gt_s (local.get $c) (i32.const 0)) (i32.or
      (i32.ne (i32.rem_u (local.get $pieces) (local.get $c)) (i32.const 0))
      (i32.ne (i32.shl (i32.add (local.get $c) (i32.div_u (local.get $pieces) (local.get $c))) (i32.const 1))
        (i32.add (local.get $border) (i32.const 4)))))))
    (select (local.get $c) (i32.div_u (local.get $pieces) (local.get $c))
      (i32.eq (local.get $format) (global.get $portrait)))
  )

  ;;
  ;; jigsawData - find the missing pieces of jigsaw puzzle data
  ;;
  ;; @param {i32} $pieces - total number of pieces*
  ;; @param {i32} $border - number of border pieces*
  ;; @param {i32} $inside - number of inside pieces*
  ;; @param {i32} $rows - number of rows*
  ;; @param {i32} $columns - number of columns*
  ;; @param {f64} $aspectRatio - aspect ratio between columns and rows*
  ;; @param {i32} $format - see formats globals*
  ;;
  ;; @returns {(i32,i32,i32,i32,i32,f64,i32)} - completed data in the same order**
  ;;
  ;; * 0 if not given
  ;; ** if an error occurs, it replaces the first return value
  ;;
  (func (export "jigsawData") (param $pieces i32) (param $border i32) (param $inside i32)
    (param $rows i32) (param $columns i32) (param $aspectRatio f64) (param $format i32)
    (result i32 i32 i32 i32 i32 f64 i32)
    (local $i i32)
    (local $r f64)
    (if (i32.eqz (local.get $pieces)) (then
      (if (i32.and (i32.ne (local.get $border) (i32.const 0)
        (i32.ne (local.get $inside) (i32.const 0))))
      (then (local.set $pieces (i32.add (local.get $border) (local.get $inside))))
      (else (if (i32.and (i32.ne (local.get $rows) (i32.const 0))
        (i32.ne (local.get $columns) (i32.const 0)))
      (then (local.set $pieces (i32.mul (local.get $rows) (local.get $columns))))
      (else (if (i32.and (i32.ne (local.get $rows) (i32.const 0))
        (f64.ne (local.get $aspectRatio) (f64.const 0.0)))
      (then (local.set $pieces (i32.mul (local.get $rows) (i32.trunc_f64_u
        (f64.mul (local.get $aspectRatio) (f64.convert_i32_u (local.get $rows)))))))
      (else (if (i32.and (i32.ne (local.get $columns) (i32.const 0))
        (f64.ne (local.get $aspectRatio) (f64.const 0.0)))
      (then (local.set $pieces (i32.mul (local.get $rows) (i32.trunc_f64_u
        (f64.div (f64.convert_i32_u (local.get $columns)) (local.get $aspectRatio))))))
      (else (if (i32.and (i32.ne (local.get $rows) (i32.const 0))
        (i32.eq (local.get $format) (global.get $square)))
      (then (local.set $pieces (i32.mul (local.get $rows) (local.get $rows))))
      (else (if (i32.and (i32.ne (local.get $columns) (i32.const 0))
        (i32.eq (local.get $format) (global.get $square)))
      (then (local.set $pieces (i32.mul (local.get $columns) (local.get $columns))))
      (else (if (i32.and (i32.ne (local.get $inside) (i32.const 0))
        (i32.or (i32.eq (local.get $format) (global.get $square))
        (f64.eq (local.get $aspectRatio) (f64.const 1.0))))
      (then (local.set $i (i32.add (i32.const 2)
        (i32.trunc_f64_u (f64.sqrt (f64.convert_i32_u (local.get $inside))))))
        (local.set $pieces (i32.mul (local.get $i) (local.get $i))))
      (else (if (i32.and (i32.ne (local.get $border) (i32.const 0))
        (i32.or (i32.eq (local.get $format) (global.get $square))
        (f64.eq (local.get $aspectRatio) (f64.const 1.0))))
      (then (local.set $i (i32.shr_u (i32.add (local.get $border) (i32.const 4)) (i32.const 2)))
        (local.set $pieces (i32.mul (local.get $i) (local.get $i)))))))))))))))))))))
    (if (i32.eqz (local.get $pieces)) (then (return (global.get $INSUFFICIENT)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $format))))
    (if (i32.eqz (local.get $columns)) (then
      (if (local.get $rows) (then (local.set $columns (i32.div_u (local.get $pieces) (local.get $rows))))
      (else (if (i32.trunc_f64_u (local.get $aspectRatio))
      (then (local.set $columns (i32.trunc_f64_u (f64.sqrt
        (f64.mul (local.get $aspectRatio) (f64.convert_i32_u (local.get $pieces)))))))
      (else (if (i32.and (i32.ne (local.get $border) (i32.const 0))
        (i32.ne (local.get $format) (i32.const 0)))
      (then (local.set $columns (call $findColumns
        (local.get $pieces) (local.get $border) (local.get $format))))
      (else (if (i32.and (i32.ne (local.get $inside) (i32.const 0))
        (i32.ne (local.get $format) (i32.const 0)))
      (then (local.set $columns (call $findColumns (local.get $pieces)
        (i32.sub (local.get $pieces) (local.get $inside)) (local.get $format)))))))))))))
    (if (i32.eqz (local.get $columns)) (then (return (global.get $INSUFFICIENT)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $format))))
    (local.set $i (i32.div_u (local.get $pieces) (local.get $columns)))
    (if (i32.eqz (local.get $rows)) (then (local.set $rows (local.get $i)))
    (else (if (i32.ne (local.get $rows) (local.get $i)) (then (return (global.get $CONTRADICTORY)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $format))))))
    (local.set $i (i32.sub (i32.shl (i32.add (local.get $rows) (local.get $columns))
      (i32.const 1)) (i32.const 4)))
    (if (i32.eqz (local.get $border)) (then (local.set $border (local.get $i)))
    (else (if (i32.ne (local.get $border) (local.get $i)) (then (return (global.get $CONTRADICTORY)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $format))))))
    (local.set $i (i32.sub (local.get $pieces) (local.get $border)))
    (if (i32.eqz (local.get $inside)) (then (local.set $inside (local.get $i)))
    (else (if (i32.ne (local.get $inside) (local.get $i)) (then (return (global.get $CONTRADICTORY)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $format))))))
    (local.set $r (f64.div (f64.convert_i32_u (local.get $columns))
      (f64.convert_i32_u (local.get $rows))))
    (if (f64.eq (local.get $aspectRatio) (f64.const 0.0)) (then (local.set $aspectRatio (local.get $r)))
    (else (if (f64.ne (local.get $aspectRatio) (local.get $r)) (then (return (global.get $CONTRADICTORY)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $r) (local.get $format))))))
    (if (i32.eq (local.get $rows) (local.get $columns)) (then (local.set $i (global.get $square)))
    (else (if (i32.lt_u (local.get $rows) (local.get $columns))
    (then (local.set $i (global.get $landscape)))
    (else (local.set $i (global.get $portrait))))))
    (if (i32.eqz (local.get $format)) (then (local.set $format (local.get $i)))
    (else (if (i32.ne (local.get $format) (local.get $i)) (then (return (global.get $CONTRADICTORY)
      (local.get $border) (local.get $inside) (local.get $rows) (local.get $columns)
      (local.get $aspectRatio) (local.get $i))))))
    (local.get $pieces) (local.get $border) (local.get $inside)
    (local.get $rows) (local.get $columns) (local.get $aspectRatio) (local.get $format)
  )
)
