(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 64))

  ;;
  ;; Recursively calculate one number from the spiral
  ;;
  ;; @param {i32} $width - remaining width of the spiral
  ;; @param {i32} $height - remaining height of the spiral
  ;; @param {i32} $x - current x position in the matrix
  ;; @param {i32} $y - current y position in the matrix
  ;;
  ;; @returns {i32} - current number
  ;;
  (func $spiral (param $width i32) (param $height i32) (param $x i32) (param $y i32) (result i32)
    (if (i32.le_s (local.get $y) (i32.const 0)) (then 
      (return (i32.add (local.get $x) (i32.const 1)))))
    (i32.add (local.get $width)
      (call $spiral (i32.sub (local.get $height) (i32.const 1)) (local.get $width)
        (i32.sub (local.get $y) (i32.const 1))
          (i32.sub (i32.sub (local.get $width) (local.get $x)) (i32.const 1))))
  )

  ;;
  ;; Generate an array of u16 numbers that when put into a square 2d-array will result in a spiral matrix
  ;;
  ;; @param {i32} $size - length of the sides of the matrix
  ;;
  ;; @returns {(i32,i32)} - offset and length of the u16 number array
  ;;
  (func (export "spiralMatrix") (param $size i32) (result i32 i32)
    (local $x i32)
    (local $y i32)
    (loop $line
      (local.set $x (i32.const 0))
      (loop $column
        (i32.store16 (i32.add (global.get $outputOffset) 
          (i32.shl (i32.add (i32.mul (local.get $y) (local.get $size))
            (local.get $x)) (i32.const 1)))
              (call $spiral (local.get $size) (local.get $size)
      (local.get $x) (local.get $y)))
        (local.set $x (i32.add (local.get $x) (i32.const 1)))
      (br_if $column (i32.le_u (local.get $x) (local.get $size))))
      (local.set $y (i32.add (local.get $y) (i32.const 1)))
    (br_if $line (i32.le_u (local.get $y) (local.get $size))))
    (global.get $outputOffset) (i32.mul (local.get $size) (local.get $size))
  )
)