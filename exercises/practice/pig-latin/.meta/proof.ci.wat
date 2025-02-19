(module
  (memory (export "mem") 1)

  (data (i32.const 0) "aeiouy")

  (global $true i32 (i32.const 1))
  (global $false i32 (i32.const 0))
  (global $outputOffset i32 (i32.const 512))
  (global $space i32 (i32.const 32))
  (global $xr i32 (i32.const 29304))
  (global $yt i32 (i32.const 29817))
  (global $qu i32 (i32.const 30065))
  (global $ay i32 (i32.const 31073))
  (global $wordBoundary i32 (i32.const 0))
  (global $vowelStarted i32 (i32.const 1))
  (global $consonantStarted i32 (i32.const 2))
  (global $consonantEnded i32 (i32.const 3))

  ;;
  ;; checks if the first of two character bytes is a vowel (or y if $withY is true)
  ;;
  ;; @param {i32} $char - 16bit of characters
  ;; @param {i32} $withY - 1 if y should be be considered a vowel (after consonant)
  ;;
  ;; @result {i32} - 1 if char is a vowel (or y if $withY is true)
  ;; 
  (func $isVowel (param $char i32) (param $withY i32) (result i32)
    (local $pos i32)
    (local.set $pos (i32.add (i32.const 5) (local.get $withY)))
    (loop $vowels
      (local.set $pos (i32.sub (local.get $pos) (i32.const 1)))
      (if (i32.eq (i32.and (local.get $char) (i32.const 255))
        (i32.load8_u (local.get $pos))) (then (return (i32.const 1))))
    (br_if $vowels (local.get $pos)))
    (i32.const 0)
  )
  
  ;;
  ;; translates text into pig latin
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputLength - length of the input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output in linear memory
  ;;
  (func (export "translate") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $char i32)
    (local $wordStart i32)
    (local $inputPos i32)
    ;; $wordBoundary (default) | $vowelStarted | $consonantStarted | $consonantEnded
    (local $mode i32) 
    (local $consonantsLength i32)
    (local $partLength i32)
    (local $outputLength i32)
    (loop $chars
      (local.set $char (i32.load16_u (i32.add (local.get $inputOffset) (local.get $inputPos))))
      ;; next character is space
      (if (i32.or (i32.eq (i32.and (local.get $char) (i32.const 255)) (global.get $space))
      ;; or we reached the end of our input
        (i32.eq (local.get $inputPos) (local.get $inputLength))) (then
          ;; write starting with the vowels (or y after consonants)
          (local.set $partLength (i32.sub (i32.sub (local.get $inputPos) (local.get $wordStart))
            (local.get $consonantsLength)))
          (memory.copy
            (i32.add (global.get $outputOffset) (local.get $outputLength))
            (i32.add (i32.add (local.get $inputOffset) (local.get $wordStart)) (local.get $consonantsLength))
            (local.get $partLength))
          (local.set $outputLength (i32.add (local.get $outputLength) (local.get $partLength)))
          ;; write starting consonants/qu, if present
          (if (local.get $consonantsLength) (then 
            (memory.copy
              (i32.add (global.get $outputOffset) (local.get $outputLength))
              (i32.add (local.get $inputOffset) (local.get $wordStart))
              (local.get $consonantsLength))
          ))
          (local.set $outputLength (i32.add (local.get $outputLength) (local.get $consonantsLength)))
          ;; write "ay"
          (i32.store16 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $ay))
          (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 2)))
          ;; set up next word
          (local.set $wordStart (i32.add (local.get $inputPos) (i32.const 1)))
          (local.set $mode (global.get $wordBoundary))
          (local.set $consonantsLength (i32.const 0))
          ;; add space to output
          (if (i32.eq (i32.and (local.get $char) (i32.const 255)) (global.get $space)) (then
            (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength)) (global.get $space))
            (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
          ))
      ) (else
        ;; word boundary
        (if (i32.eqz (local.get $mode)) (then 
          ;; with a vowel, xt or yr -> set mode to vowel start
          (if (i32.or (i32.or (call $isVowel (local.get $char) (global.get $false))
            (i32.eq (local.get $char) (global.get $xr)))
            (i32.eq (local.get $char) (global.get $yt))) (then
              (local.set $mode (global.get $vowelStarted))
          ;; with a consonant
          ) (else 
            (local.set $mode (global.get $consonantStarted))
            (local.set $consonantsLength (i32.const 1))
          ))
        ) (else 
          ;; consonant start mode
          (if (i32.eq (local.get $mode) (global.get $consonantStarted)) (then
            ;; count more consonants or set mode to end of consonants
            (if (call $isVowel (local.get $char) (global.get $true)) (then
              (local.set $mode (global.get $consonantEnded))
            ) (else
              (local.set $consonantsLength (i32.add (local.get $consonantsLength) (i32.const 1)))
            ))
        ))))
        ;; handle qu in consonant started mode (skip the "u")
        (if (i32.and (i32.eq (local.get $mode) (global.get $consonantStarted)) 
          (i32.eq (local.get $char) (global.get $qu))) (then
          (local.set $consonantsLength (i32.add (local.get $consonantsLength) (i32.const 1)))
          (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 1)))))
      ))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 1)))
    (br_if $chars (i32.le_u (local.get $inputPos) (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)
