(module
  (memory (export "mem") 1)
  (data (i32.const 0) "\08\04\0c\0c\18\0f\27\04winkdouble blinkclose your eyesjump")

  (global $outputOffset i32 (i32.const 64))
  (global $reverse i32 (i32.const 16))
  (global $commaSpace i32 (i32.const 8236))

  ;;
  ;; Output the list of commands to perform the secret handshake as a string, using a comma and a space as separators.
  ;;
  ;; @param {i32} number - the secret number that defines the handshake
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "commands") (param $number i32) (result i32 i32)
    (local $commandIndex i32)
    (local $part i32)
    (local $step i32)
    (local $outputLength i32)
    (if (i32.and (local.get $number) (global.get $reverse)) (then 
      (local.set $commandIndex (i32.const 3))
      (local.set $step (i32.const -1))
    ) (else (local.set $step (i32.const 1))))
    (loop $steps
      (if (i32.and (local.get $number) (i32.shl (i32.const 1) (local.get $commandIndex))) (then
        ;; add comma + space after previous commands
        (if (local.get $outputLength) (then
          (i32.store16 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $commaSpace))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 2)))))
        ;; get index and length of current part
        (local.set $part (i32.load16_u (i32.shl (local.get $commandIndex) (i32.const 1))))
        (memory.copy 
          (i32.add (global.get $outputOffset) (local.get $outputLength))
          (i32.and (local.get $part) (i32.const 255))
          (i32.shr_u (local.get $part) (i32.const 8)))
        (local.set $outputLength (i32.add (local.get $outputLength)
          (i32.shr_u (local.get $part) (i32.const 8))))
      ))
      (local.set $commandIndex (i32.add (local.get $commandIndex) (local.get $step)))
    (br_if $steps (i32.rem_s (i32.add (local.get $commandIndex) (i32.const 1)) (i32.const 5))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)