(module
  (import "console" "log_f64" (func $log_f64 (param f64)))
  ;;
  ;; Find the greatest common denominator of two numbers
  ;;
  ;; @param {i32} $a - first number
  ;; @param {i32} $b - second number
  ;;
  ;; @returns {i32} - greatest common denominator of $a and $b
  ;;
  (func $gcd (param $a i32) (param $b i32) (result i32)
    (if (i32.eqz (local.get $b)) (then (return (local.get $a))))
    (call $gcd (local.get $b) (i32.rem_s (local.get $a) (local.get $b)))
  )

  ;;
  ;; Exponentiate integers: x ^ y
  ;;
  ;; @param {i32} $x - base
  ;; @param {i32} $y - exponent
  ;;
  ;; @result {i32} exponent
  ;;
  (func $powi (param $x i32) (param $y i32) (result i32)
    (if (i32.eqz (local.get $y)) (then (return (i32.const 1))))
    (i32.mul (local.get $x) (call $powi (local.get $x) (i32.sub (local.get $y) (i32.const 1))))
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
    (local $prev f64)
    (local $fac f64)
    (local $step f64)
    (local.set $sum (f64.add (f64.const 1.0) (local.get $num)))
    (local.set $product (local.get $num))
    (local.set $step (f64.const 3.0))
    (local.set $fac (f64.const 2.0))
    (loop $series
      (local.set $prev (local.get $sum))
      (local.set $product (f64.mul (local.get $product) (local.get $num)))
      (local.set $sum (f64.add (local.get $sum) (f64.div (local.get $product) (local.get $fac))))
      (local.set $fac (f64.mul (local.get $fac) (local.get $step)))
      (local.set $step (f64.add (local.get $step) (f64.const 1.0)))
    (br_if $series (f64.ne (local.get $sum) (local.get $prev))))
    (local.get $sum)
  )

  ;;
  ;; logarithm function for positive numbers
  ;;
  ;; @param $num {f64} - the number for which the logarithm should be calculated
  ;;
  ;; @returns {f64} - the logarithm log(num)
  ;;
  (func $log (param $num f64) (result f64)
    (local $step f64)
    (local $term f64)
    (local $prev f64)
    (local $ratio f64)
    (local $total f64)
    (if (f64.eq (local.get $num) (f64.const 0)) (then (return (f64.const 0))))
    (local.set $step (f64.const 1.0))
    (local.set $term (f64.div (f64.sub (local.get $num) (f64.const 1)) (f64.add (local.get $num) (f64.const 1))))
    (local.set $ratio (f64.mul (local.get $term) (local.get $term)))
    (local.set $total (local.get $term))
    (loop $series
      (local.set $prev (local.get $total))
      (local.set $term (f64.mul (local.get $ratio) (local.get $term)))
      (local.set $step (f64.add (local.get $step) (f64.const 2)))
      (local.set $total (f64.add (local.get $total) (f64.div (local.get $term) (local.get $step))))
    (br_if $series (f64.ne (local.get $prev) (local.get $total))))
    (f64.mul (local.get $total) (f64.const 2))
  )

  ;;
  ;; Exponentiate floating point numbers: x ^ y = exp(y * log(x))
  ;;
  ;; @param {f64} $x - base
  ;; @param {f64} $y - exponent
  ;;
  ;; @result {f64} exponent
  ;;
  (func $powf (param $x f64) (param $y f64) (result f64)
    (if (f64.eq (local.get $x) (f64.const 0)) (then (return (f64.const 0.0))))
    (call $exp (f64.mul (local.get $y) (call $log (local.get $x))))
  )

  ;;
  ;; Add two rational numbers
  ;;
  ;; @param {i32} $numeratorA - numerator of the first rational number
  ;; @param {i32} $denominatorA - denominator of the first rational number
  ;; @param {i32} $numeratorB - numerator of the second rational number
  ;; @param {i32} $denominatorB - denominator of the second rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "add") (param $numeratorA i32) (param $denominatorA i32)
    (param $numeratorB i32) (param $denominatorB i32) (result i32 i32)
    (local $numerator i32)
    (local.tee $numerator (i32.add (i32.mul (local.get $numeratorA) (local.get $denominatorB))
      (i32.mul (local.get $numeratorB) (local.get $denominatorA))))
    (select (i32.mul (local.get $denominatorA) (local.get $denominatorB)) (i32.const 1) (local.get $numerator))
  )

  ;;
  ;; Subtract two rational numbers
  ;;
  ;; @param {i32} $numeratorA - numerator of the first rational number
  ;; @param {i32} $denominatorA - denominator of the first rational number
  ;; @param {i32} $numeratorB - numerator of the second rational number
  ;; @param {i32} $denominatorB - denominator of the second rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "sub") (param $numeratorA i32) (param $denominatorA i32)
    (param $numeratorB i32) (param $denominatorB i32) (result i32 i32)
    (local $numerator i32)
    (local.tee $numerator (i32.sub (i32.mul (local.get $numeratorA) (local.get $denominatorB))
      (i32.mul (local.get $numeratorB) (local.get $denominatorA))))
    (select (i32.mul (local.get $denominatorA) (local.get $denominatorB)) (i32.const 1) (local.get $numerator))
  )

  ;;
  ;; Multiply two rational numbers
  ;;
  ;; @param {i32} $numeratorA - numerator of the first rational number
  ;; @param {i32} $denominatorA - denominator of the first rational number
  ;; @param {i32} $numeratorB - numerator of the second rational number
  ;; @param {i32} $denominatorB - denominator of the second rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "mul") (param $numeratorA i32) (param $denominatorA i32)
    (param $numeratorB i32) (param $denominatorB i32) (result i32 i32)
    (call $reduce (i32.mul (local.get $numeratorA) (local.get $numeratorB))
      (i32.mul (local.get $denominatorA) (local.get $denominatorB)))
  )

  ;;
  ;; Divide two rational numbers
  ;;
  ;; @param {i32} $numeratorA - numerator of the first rational number
  ;; @param {i32} $denominatorA - denominator of the first rational number
  ;; @param {i32} $numeratorB - numerator of the second rational number
  ;; @param {i32} $denominatorB - denominator of the second rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "div") (param $numeratorA i32) (param $denominatorA i32)
    (param $numeratorB i32) (param $denominatorB i32) (result i32 i32)
    (call $reduce (i32.mul (local.get $numeratorA) (local.get $denominatorB))
      (i32.mul (local.get $denominatorA) (local.get $numeratorB)))
  )

  ;;
  ;; Absolute of a rational number
  ;;
  ;; @param {i32} $numerator - numerator of the rational number
  ;; @param {i32} $denominator - denominator of the rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "abs") (param $numerator i32) (param $denominator i32) (result i32 i32)
    (select (local.get $numerator) (i32.sub (i32.const 0) (local.get $numerator))
      (i32.ge_s (local.get $numerator) (i32.const 0)))
    (select (local.get $denominator) (i32.sub (i32.const 0) (local.get $denominator))
      (i32.ge_s (local.get $denominator) (i32.const 0)))
  )

  ;;
  ;; Exponentiate a rational number with another integer
  ;;
  ;; @param {i32} $numerator - numerator of the rational number
  ;; @param {i32} $denominator - denominator of the rational number
  ;; @param {i32} $exp - integer power
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func $exprational (export "exprational") (param $numerator i32) (param $denominator i32) (param $exp i32) (result i32 i32)
    (if (i32.lt_s (local.get $exp) (i32.const 0)) (then (return
      (call $exprational (local.get $denominator) (local.get $numerator) (i32.sub (i32.const 0) (local.get $exp))))))
    (call $powi (local.get $numerator) (local.get $exp))
    (call $powi (local.get $denominator) (local.get $exp))
  )

  ;;
  ;; Exponentiate a rational number with a floating point number
  ;;
  ;; @param {i32} $numerator - numerator of the first rational number
  ;; @param {i32} $denominator - denominator of the first rational number
  ;; @param {i32} $exp - floating point power
  ;;
  ;; @returns {f64} - floating point result
  ;;
  (func (export "expreal") (param $numerator i32) (param $denominator i32) (param $exp f64) (result f64)
    (call $powf (call $powf (local.get $exp)
      (f64.div (f64.const 1) (f64.convert_i32_s (local.get $denominator))))
      (f64.convert_i32_s (local.get $numerator)))
  )

  ;;
  ;; Reduce a rational number
  ;;
  ;; @param {i32} $numerator - numerator of the rational number
  ;; @param {i32} $denominator - denominator of the rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func $reduce (export "reduce") (param $numerator i32) (param $denominator i32) (result i32 i32)
    (local $divisor i32)
    (local.set $divisor (call $gcd (local.get $numerator) (local.get $denominator)))
    (if (i32.lt_s (i32.mul (local.get $divisor) (local.get $denominator)) (i32.const 0)) (then
      (local.set $divisor (i32.sub (i32.const 0) (local.get $divisor)))))
    (i32.div_s (local.get $numerator) (local.get $divisor))
    (i32.div_s (local.get $denominator) (local.get $divisor))
  )
)