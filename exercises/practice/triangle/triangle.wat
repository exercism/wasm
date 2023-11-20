(module
  ;;
  ;; Is the triangle equilateral?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if equalateral, 0 otherwise
  ;;
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
    (i32.const 42)
  )

  ;;
  ;; Is the triangle isosceles?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if isosceles, 0 otherwise
  ;;
  (func (export "isIsosceles") (param f32 f32 f32) (result i32)
    (i32.const 42)
  )

  ;;
  ;; Is the triangle scalene?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if scalene, 0 otherwise
  ;;
  (func (export "isScalene") (param f32 f32 f32) (result i32)
    (i32.const 42)
  )
)
