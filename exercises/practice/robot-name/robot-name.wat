(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 1)

  ;;
  ;; Generate a new name for a robot, consisting of two uppercase letters and three numbers,
  ;; avoiding already used names
  ;;
  ;; @results {(i32,i32)} - offset and length in linear memory
  ;;
  (func (export "generateName") (result i32 i32)
    (i32.const 0) (i32.const 0)
  )

  ;;
  ;; Release already used names so that they can be re-used
  ;;
  (func (export "releaseNames"))
)