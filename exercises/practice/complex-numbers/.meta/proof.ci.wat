(module
  ;; precision value p => 1/p!
  (global $precision f64 (f64.const 26.0))

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
    (f64.add (local.get $realA) (local.get $realB))
    (f64.add (local.get $imagA) (local.get $imagB))
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
    (f64.sub (local.get $realA) (local.get $realB))
    (f64.sub (local.get $imagA) (local.get $imagB))
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
    (f64.sub (f64.mul (local.get $realA) (local.get $realB))
      (f64.mul (local.get $imagA) (local.get $imagB)))
    (f64.add (f64.mul (local.get $imagA) (local.get $realB))
      (f64.mul (local.get $imagB) (local.get $realA)))
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
    (f64.div (f64.add (f64.mul (local.get $realA) (local.get $realB))
      (f64.mul (local.get $imagA) (local.get $imagB)))
      (f64.add (f64.mul (local.get $realB) (local.get $realB))
      (f64.mul (local.get $imagB) (local.get $imagB))))
    (f64.div (f64.sub (f64.mul (local.get $imagA) (local.get $realB))
      (f64.mul (local.get $realA) (local.get $imagB)))
      (f64.add (f64.mul (local.get $realB) (local.get $realB))
      (f64.mul (local.get $imagB) (local.get $imagB))))
  )

  ;;
  ;; returns the absolute of a complex number
  ;;
  ;; @param $real {f64} - the real part of the number
  ;; @param $imag {f64} - the imaginary part of the number
  ;;
  ;; @returns {f64} - the absolute value of the number
  ;;
  (func (export "abs") (param $real f64) (param $imag f64) (result f64)
    (f64.sqrt (f64.add (f64.mul (local.get $real) (local.get $real))
      (f64.mul (local.get $imag) (local.get $imag))))
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
    (local.get $real) (f64.sub (f64.const 0.0) (local.get $imag))
  )

  ;;
  ;; exponential function
  ;;
  ;; @param $num {f64} - the number for which the exponent should be calculated
  ;;
  ;; @returns {f64} - the exponential e^num
  ;;
  (func $exp (param $num f64) (result f64)
    (local $product f64)
    (local $sum f64)
    (local $fac f64)
    (local $step f64)
    (local.set $sum (f64.add (f64.const 1.0) (local.get $num)))
    (local.set $product (local.get $num))
    (local.set $step (f64.const 3.0))
    (local.set $fac (f64.const 2.0))
    (loop $series
      (local.set $product (f64.mul (local.get $product) (local.get $num)))
      (local.set $sum (f64.add (local.get $sum) (f64.div (local.get $product) (local.get $fac))))
      (local.set $fac (f64.mul (local.get $fac) (local.get $step)))
      (local.set $step (f64.add (local.get $step) (f64.const 1.0)))
    (br_if $series (f64.lt (local.get $step) (global.get $precision))))
    (local.get $sum)
  )

  ;;
  ;; radial sine of a number
  ;;
  ;; @param $num {f64} - the number for which the sine should be calculated
  ;;
  ;; @returns {f64} - the sine of the number
  ;;
  (func $sin (param $num f64) (result f64)
    (local $sum f64)
    (local $square f64)
    (local $product f64)
    (local $fac f64)
    (local $step f64)
    (local.set $sum (local.get $num))
    (local.set $square (f64.mul (local.get $num) (local.get $num)))
    (local.set $product (local.get $num))
    (local.set $fac (f64.const 6.0))
    (local.set $step (f64.const 4.0))
    (loop $series
      (local.set $product (f64.mul (local.get $product) (local.get $square)))
      (local.set $sum (f64.add (local.get $sum) (f64.div 
        (select (local.get $product) (f64.sub (f64.const 0) (local.get $product)) 
          (i32.and (i32.trunc_f64_u (local.get $step)) (i32.const 2)))
        (local.get $fac))))
      (local.set $fac (f64.mul (f64.mul (local.get $fac) (local.get $step))
        (f64.add (local.get $step) (f64.const 1.0))))
      (local.set $step (f64.add (local.get $step) (f64.const 2)))
    (br_if $series (f64.lt (local.get $step) (global.get $precision))))
    (local.get $sum)
  )

  ;;
  ;; radial cosine of a number
  ;;
  ;; @param $num {f64} - the number for which the cosine should be calculated
  ;;
  ;; @returns {f64} - the cosine of the number
  ;;
  (func $cos (param $num f64) (result f64)
    (local $sum f64)
    (local $square f64)
    (local $product f64)
    (local $fac f64)
    (local $step f64)
    (local.set $sum (f64.const 1))
    (local.set $square (f64.mul (local.get $num) (local.get $num)))
    (local.set $product (f64.const 1))
    (local.set $fac (f64.const 2.0))
    (local.set $step (f64.const 3.0))
    (loop $series
      (local.set $product (f64.mul (local.get $product) (local.get $square)))
      (local.set $sum (f64.add (local.get $sum) (f64.div 
        (select (f64.sub (f64.const 0) (local.get $product)) (local.get $product)
          (i32.and (i32.trunc_f64_u (local.get $step)) (i32.const 2)))
        (local.get $fac))))
      (local.set $fac (f64.mul (f64.mul (local.get $fac) (local.get $step))
        (f64.add (local.get $step) (f64.const 1.0))))
      (local.set $step (f64.add (local.get $step) (f64.const 2)))
    (br_if $series (f64.lt (local.get $step) (global.get $precision))))
    (local.get $sum)
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
    (local $expReal f64)
    (local.set $expReal (call $exp (local.get $real)))
    (f64.mul (local.get $expReal) (call $cos (local.get $imag)))
    (f64.mul (local.get $expReal) (call $sin (local.get $imag)))
  )
)
