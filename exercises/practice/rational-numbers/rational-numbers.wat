(module
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
    (i32.const 0) (i32.const 1)
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
    (i32.const 0) (i32.const 1)
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
    (i32.const 0) (i32.const 1)
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
    (i32.const 0) (i32.const 1)
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
    (i32.const 0) (i32.const 1)
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
  (func (export "exprational") (param $numerator i32) (param $denominator i32) (param $exp i32) (result i32 i32)
    (i32.const 0) (i32.const 1)
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
  (func (export "expreal") (param $numerator i32) (param $denominator i32) (param $exp i32) (result f64)
    (f64.const 1.0)
  )

  ;;
  ;; Reduce a rational number
  ;;
  ;; @param {i32} $numerator - numerator of the rational number
  ;; @param {i32} $denominator - denominator of the rational number
  ;;
  ;; @returns {(i32,i32)} - numerator and denominator of the result
  ;;
  (func (export "reduce") (param $numerator i32) (param $denominator i32) (result i32 i32)
    (i32.const 0) (i32.const 1)
  )
)