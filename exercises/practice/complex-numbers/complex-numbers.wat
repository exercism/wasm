(module
  ;;
  ;; adds two complex numbers
  ;;
  ;; @param $realA {f64} - the real part of the first number
  ;; @param $imagA {f64} - the imaginary part of the first number
  ;; @param $realB {f64} - the real part of the second number
  ;; @param $imagB {f64} - the imaginary part of the second number
  ;;
  ;; @returns {(f64,f64)} - the real and imaginary parts of the complex sum
  ;;
  (func (export "add") (param $realA f64) (param $imagA f64) (param $realB f64) (param $imagB f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )

  ;;
  ;; subtracts two complex numbers
  ;;
  ;; @param $realA {f64} - the real part of the first number
  ;; @param $imagA {f64} - the imaginary part of the first number
  ;; @param $realB {f64} - the real part of the second number
  ;; @param $imagB {f64} - the imaginary part of the second number
  ;;
  ;; @returns {(f64,f64)} - the real and imaginary parts of the complex difference
  ;;
  (func (export "sub") (param $realA f64) (param $imagA f64) (param $realB f64) (param $imagB f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )

  ;;
  ;; multiplicates two complex numbers
  ;;
  ;; @param $realA {f64} - the real part of the first number
  ;; @param $imagA {f64} - the imaginary part of the first number
  ;; @param $realB {f64} - the real part of the second number
  ;; @param $imagB {f64} - the imaginary part of the second number
  ;;
  ;; @returns {(f64,f64)} - the real and imaginary parts of the complex product
  ;;
  (func (export "mul") (param $realA f64) (param $imagA f64) (param $realB f64) (param $imagB f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )

  ;;
  ;; divides two complex numbers
  ;;
  ;; @param $realA {f64} - the real part of the first number
  ;; @param $imagA {f64} - the imaginary part of the first number
  ;; @param $realB {f64} - the real part of the second number
  ;; @param $imagB {f64} - the imaginary part of the second number
  ;;
  ;; @returns {(f64,f64)} - the real and imaginary parts of the complex quotient
  ;;
  (func (export "div") (param $realA f64) (param $imagA f64) (param $realB f64) (param $imagB f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )

  ;;
  ;; returns the absolute of a complex number
  ;;
  ;; @param $real {f64} - the real part of the number
  ;; @param $imag {f64} - the imaginary part of the number
  ;;
  ;; @returns {f64} - the absolute of the number
  ;;
  (func (export "abs") (param $real f64) (param $imag f64) (result f64)
    (f64.const 0.0)
  )

  ;;
  ;; returns the conjugate of a complex number
  ;;
  ;; @param $real {f64} - the real part of the number
  ;; @param $imag {f64} - the imaginary part of the number
  ;;
  ;; @returns {(f64,f64)} - the real and imaginary parts of the conjugate of the number
  ;;
  (func (export "conj") (param $real f64) (param $imag f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )

  ;;
  ;; returns the exponentiation of a complex number
  ;;
  ;; @param $real {f64} - the real part of the number
  ;; @param $imag {f64} - the imaginary part of the number
  ;;
  ;; @returns {(f64,f64}} - exponentiation of the complex number
  ;;
  (func (export "exp") (param $real f64) (param $imag f64) (result f64 f64)
    (f64.const 0.0) (f64.const 0.0)
  )
)
