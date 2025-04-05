(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 96)

  (global $length (mut i32) (i32.const 0))
  (global $outputOffset i32 (i32.const 2704384))
  (global $outputLength i32 (i32.const 5))
  (global $letter i32 (i32.const 65))
  (global $number i32 (i32.const 48))
  ;;
  ;; Generate a new name for a robot, consisting of two uppercase letters and three numbers,
  ;; avoiding already used names
  ;;
  ;; @results {(i32,i32)} - offset and length in linear memory
  ;;
  (func (export "generateName") (result i32 i32)
    (local $pos i32)
    (local $id i32)
    (if (i32.eqz (global.get $length)) (then (return (i32.const 0) (i32.const 0))))
    (local.set $pos (i32.shl (i32.trunc_f64_u (f64.mul (call $random)
      (f64.convert_i32_u (global.get $length)))) (i32.const 2)))
    (local.set $id (i32.load (local.get $pos)))
    (global.set $length (i32.sub (global.get $length) (i32.const 1)))
    (i32.store (local.get $pos) (i32.load (i32.shl (global.get $length) (i32.const 2))))
    (i32.store8 (global.get $outputOffset)
      (i32.add (i32.div_u (local.get $id) (i32.const 26000)) (global.get $letter)))
    (i32.store8 (i32.add (global.get $outputOffset) (i32.const 1))
      (i32.add (i32.rem_u (i32.div_u (local.get $id) (i32.const 1000))
        (i32.const 26)) (global.get $letter)))
    (i32.store8 (i32.add (global.get $outputOffset) (i32.const 2))
      (i32.add (i32.rem_u (i32.div_u (local.get $id) (i32.const 100))
        (i32.const 10)) (global.get $number)))
    (i32.store8 (i32.add (global.get $outputOffset) (i32.const 3))
      (i32.add (i32.rem_u (i32.div_u (local.get $id) (i32.const 10))
        (i32.const 10)) (global.get $number)))
    (i32.store8 (i32.add (global.get $outputOffset) (i32.const 4))
      (i32.add (i32.rem_u (local.get $id) (i32.const 10)) (global.get $number)))
    (global.get $outputOffset) (global.get $outputLength)
  )

  ;;
  ;; Releases already used names
  ;;
  (func $releaseNames (export "releaseNames")
    (global.set $length (i32.const 0))
    (loop $release
      (i32.store (i32.shl (global.get $length) (i32.const 2)) (global.get $length))
      (global.set $length (i32.add (global.get $length) (i32.const 1)))
    (br_if $release (i32.lt_u (global.get $length) (i32.const 676000))))
  )
)