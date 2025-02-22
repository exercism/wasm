(module
  (memory (export "mem") 1)

  (global $notCoprimeError i32 (i32.const -1))
  (global $outputOffset i32 (i32.const 512))
  (global $letters i32 (i32.const 26))
  (global $toLower i32 (i32.const 32))
  (global $normalizeLetter i32 (i32.const 26000))
  (global $space i32 (i32.const 32))
  (global $zero i32 (i32.const 48))
  (global $nine i32 (i32.const 57))
  (global $a i32 (i32.const 97))
  (global $z i32 (i32.const 122))

  ;;
  ;; checks if key is coprime to the number of letters
  ;;
  ;; @param {i32} $keyA - part of the key that must not be coprime with number of letters
  ;;
  ;; @returns {i32} 1 (true) or 0 (false) whether the key is coprime with number of letters
  ;;
  (func $isCoprime (param $keyA i32) (result i32)
    (i32.and (i32.ne (i32.rem_u (local.get $keyA) (i32.const 2)) (i32.const 0))
      (i32.ne (i32.rem_u (local.get $keyA) (i32.const 13)) (i32.const 0)))
  )

  ;;
  ;; encode text with affine cipher
  ;;
  ;; @param {i32} $inputOffset - offset of input text in linear memory
  ;; @param {i32} $inputLength - length of input text in linear memory
  ;; @param {i32} $keyA - first part of the key
  ;; @param {i32} $keyB - second part of the key
  ;;
  ;; @returns {(i32,i32)} - encoded output offset and length in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (param $keyA i32) (param $keyB i32) (result i32 i32)
    (local $inputPos i32)
    (local $char i32)
    (local $outputLength i32)
    (if (i32.eqz (call $isCoprime (local.get $keyA))) (then
      (return (global.get $outputOffset) (global.get $notCoprimeError))))
    (loop $chars
      ;; if we already have another block of 5 characters, add a space
      (if (i32.mul (local.get $outputLength)
        (i32.eq (i32.rem_u (local.get $outputLength) (i32.const 6)) (i32.const 5))) (then 
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $space))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
      ))
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $inputPos))))
      ;; write numeric characters
      (if (i32.and (i32.ge_u (local.get $char) (global.get $zero))
        (i32.le_u (local.get $char) (global.get $nine))) (then
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $char))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1))))
      ;; handle alphabetic characters
      (else
        (local.set $char (i32.or (local.get $char) (global.get $toLower)))
        (if (i32.and (i32.ge_u (local.get $char) (global.get $a))
          (i32.le_u (local.get $char) (global.get $z))) (then
            (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
              (i32.add (i32.rem_s (i32.add (i32.mul (i32.sub (local.get $char) (global.get $a))
                (local.get $keyA)) (local.get $keyB)) (global.get $letters)) (global.get $a)))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
      ))))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $inputPos) (local.get $inputLength))))
    ;; trim suffixed spaces
    (loop $trim
      (if (i32.eq (i32.load8_u (i32.sub (i32.add (global.get $outputOffset)
        (local.get $outputLength)) (i32.const 1))) (global.get $space)) (then
          (local.set $outputLength (i32.sub (local.get $outputLength) (i32.const 1)))
          (br $trim))))
    (global.get $outputOffset) (local.get $outputLength)
  )

  ;;
  ;; decode text with affine cipher
  ;;
  ;; @param {i32} $inputOffset - offset of input text in linear memory
  ;; @param {i32} $inputLength - length of input text in linear memory
  ;; @param {i32} $keyA - first part of the key
  ;; @param {i32} $keyB - second part of the key
  ;;
  ;; @returns {(i32,i32)} - decoded output offset and length in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (param $keyA i32) (param $keyB i32) (result i32 i32)
    (local $inputPos i32)
    (local $char i32)
    (local $outputLength i32)
    (local $mmi i32)
    (if (i32.eqz (call $isCoprime (local.get $keyA))) (then
      (return (global.get $outputOffset) (global.get $notCoprimeError))))
    ;; find modular multiplicative inverse of $keyA
    (loop $find_mmi
      (local.set $mmi (i32.add (local.get $mmi) (i32.const 1)))
    (br_if $find_mmi (i32.and (i32.ne (i32.rem_s (i32.mul (local.get $keyA) (local.get $mmi))
      (global.get $letters)) (i32.const 1)) (i32.lt_u (local.get $mmi) (global.get $letters)))))
    (loop $chars
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $inputPos))))
      ;; handle numeric characters
      (if (i32.and (i32.ge_u (local.get $char) (global.get $zero))
        (i32.le_u (local.get $char) (global.get $nine))) (then
          (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (local.get $char))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1))))
      (else
      ;; handle alphabetic characters
        (local.set $char (i32.or (local.get $char) (global.get $toLower)))
        (if (i32.and (i32.ge_u (local.get $char) (global.get $a))
          (i32.le_u (local.get $char) (global.get $z))) (then
            (local.set $char (i32.rem_u (i32.add (i32.mul (local.get $mmi) (i32.sub 
              (i32.sub (local.get $char) (global.get $a)) (local.get $keyB)))
              (global.get $normalizeLetter)) (global.get $letters)))
            (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
              (i32.add (local.get $char) (global.get $a)))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
      ))))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $inputPos) (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)