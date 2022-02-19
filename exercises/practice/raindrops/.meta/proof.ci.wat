(module
  (memory (export "mem") 1)

  (data $pling "Pling")
  (data $plang "Plang")
  (data $plong "Plong")

  (global $plingLength i32 (i32.const 5))
  (global $plangLength i32 (i32.const 5))
  (global $plongLength i32 (i32.const 5))
  (global $zeroCharCode i32 (i32.const 48))

  ;; returns the number of bytes written
  ;; doesn't handle negative numbers
  (func $printU32 (param $input i32) (param $offset i32) (result i32)
    (local $length i32)
    (local $digit i32)
    (local $high i32)   
    (local $low i32)
    (local $temp i32)
    (local.set $length (i32.const 0))

    (if (i32.eqz (local.get $input)) (then
      (i32.store8 (local.get $offset) (global.get $zeroCharCode))
      (return (i32.const 1))
    ) (else 
      (loop
        (local.set $digit (i32.rem_u (local.get $input) (i32.const 10)))
        (local.set $input (i32.div_u (local.get $input) (i32.const 10)))
        (i32.store8 (i32.add (local.get $offset) (local.get $length)) (i32.add (global.get $zeroCharCode) (local.get $digit)))
        (local.set $length (i32.add (local.get $length) (i32.const 1)))
        (br_if 0 (i32.gt_u (local.get $input) (i32.const 0)))
      )
      ;; the string is backwards, so reverse
      (local.set $low (local.get $offset))
      (local.set $high (i32.sub (i32.add (local.get $offset) (local.get $length)) (i32.const 1)))
      (if (i32.lt_u (local.get $low) (local.get $high))(then (loop
        (local.set $temp (i32.load8_u (local.get $high)))
        (i32.store8 (local.get $high) (i32.load8_u (local.get $low)))
        (i32.store8 (local.get $low) (local.get $temp))

        (br_if 0 (i32.lt_u 
          (local.tee $low (i32.add (local.get $low) (i32.const 1))) 
          (local.tee $high (i32.sub (local.get $high) (i32.const 1))) 
        ))
      )))
    ))
    (local.get $length)
  )

  (func (export "convert") (param $input i32) (result i32 i32)
    (local $returnOffset i32)
    (local $returnLength i32)
    (local.set $returnOffset (i32.const 100))
    (local.set $returnLength (i32.const 0))

    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 3))) (then
      (memory.init $pling (i32.add (local.get $returnOffset) (local.get $returnLength)) (i32.const 0) (global.get $plingLength))
      (local.set $returnLength (i32.add (local.get $returnLength) (global.get $plingLength)))
    ))

    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 5))) (then
      (memory.init $plang (i32.add (local.get $returnOffset) (local.get $returnLength))(i32.const 0) (global.get $plangLength))
      (local.set $returnLength (i32.add (local.get $returnLength) (global.get $plangLength)))
    ))

    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 7))) (then
      (memory.init $plong (i32.add (local.get $returnOffset) (local.get $returnLength))(i32.const 0) (global.get $plongLength))
      (local.set $returnLength (i32.add (local.get $returnLength) (global.get $plongLength)))
    ))

    (if (i32.eqz (local.get $returnLength)) (then
      (local.set $returnLength (call $printU32 (local.get $input) (local.get $returnOffset)))
    ))

    (return (local.get $returnOffset) (local.get $returnLength))
  )
)
