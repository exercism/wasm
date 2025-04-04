(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 512))
  (global $zero i32 (i32.const 48))
  (global $nine i32 (i32.const 57))
  (global $A i32 (i32.const 65))
  (global $Z i32 (i32.const 90))
  (global $lower i32 (i32.const 32))
  (global $start i32 (i32.const 123))
  (global $stop i32 (i32.const 125))
  (global $reset i32 (i32.const 93))
  (global $equals i32 (i32.const 58))
  (global $quot i32 (i32.const 34))
  (global $delim i32 (i32.const 44))

  ;;
  ;; Rewrite the incoming JSON to the new ETL format
  ;;
  ;; @param {i32} $inputOffset - offset of the JSON input in linear memory
  ;; @param {i32} $inputLength - length of the JSON input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the JSON output in linear memory
  ;;
  (func (export "transform") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $char i32)
    (local $number i32)
    (local $inputPos i32)
    (local $outputLength i32)
    (i32.store8 (global.get $outputOffset) (global.get $start))
    (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    (loop $chars
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $inputPos))))
      (if (i32.eq (local.get $char) (global.get $reset)) (then (local.set $number (i32.const 0))))
      (if (i32.and (i32.ge_u (local.get $char) (global.get $zero))
        (i32.le_u (local.get $char) (global.get $nine))) 
          (then (local.set $number (i32.add (i32.mul (local.get $number) (i32.const 10))
            (i32.sub (local.get $char) (global.get $zero))))))
      (if (i32.and (i32.ge_u (local.get $char) (global.get $A))
        (i32.le_u (local.get $char) (global.get $Z))) (then
          (if (i32.gt_u (local.get $outputLength) (i32.const 1)) (then 
            (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $delim))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))))
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $quot))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
            (i32.or (local.get $char) (global.get $lower)))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $quot))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $equals))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
          (if (i32.ge_u (local.get $number) (i32.const 10)) (then
            (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) 
              (i32.add (i32.div_u (local.get $number) (i32.const 10)) (global.get $zero)))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))))
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) 
            (i32.add (i32.rem_u (local.get $number) (i32.const 10)) (global.get $zero)))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        ))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $inputPos) (local.get $inputLength))))
    (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $stop))
    (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
    (global.get $outputOffset) (local.get $outputLength)
  )
)
