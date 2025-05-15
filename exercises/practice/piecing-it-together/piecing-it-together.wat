(module
  ;; formats
  (global $landscape (export "landscape") i32 (i32.const 1))
  (global $square (export "square") i32 (i32.const 2))
  (global $portrait (export "portrait") i32 (i32.const 3))
  ;; errors
  (global $INSUFFICIENT (export "INSUFFICIENT") i32 (i32.const -2))
  (global $CONTRADICTORY (export "CONTRADICTORY") i32 (i32.const -3))

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
  ;; @returns {(i32,i32,i32,i32,i32,f64,i32)} - complemented data in the same order**
  ;;
  ;; * 0 if not given
  ;; ** if an error occurs, it replaces the first return value
  ;;
  (func (export "jigsawData") (param $pieces i32) (param $border i32) (param $inside i32)
    (param $rows i32) (param $columns i32) (param $aspectRatio f64) (param $format i32)
    (result i32 i32 i32 i32 i32 f64 i32)
    (local.get $pieces) (local.get $border) (local.get $inside)
    (local.get $rows) (local.get $columns) (local.get $aspectRatio) (local.get $format)
  )
)
