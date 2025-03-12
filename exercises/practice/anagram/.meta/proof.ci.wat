(module
  (memory (export "mem") 1)

  (global $lineBreak i32 (i32.const 10))
  (global $toLower i32 (i32.const 32))
  (global $a i32 (i32.const 97))
  (global $z i32 (i32.const 122))
  (global $wordLetterCount i32 (i32.const 512))
  (global $anagramLetterCount i32 (i32.const 540))
  (global $outputOffset i32 (i32.const 1024))

  ;;
  ;; Find the anagrams to the first word in the string of subsequent words
  ;;
  ;; @param {i32} $inputOffset - offset of the word list in linear memory
  ;; @param {i32} $inputLength - length of the word list in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output word list
  ;;
  (func (export "findAnagrams") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $pos i32)
    (local $char i32)
    (local $start i32)
    (local $length i32)
    (local $outputLength i32)
    (memory.fill (global.get $wordLetterCount) (i32.const 0) (i32.const 26))
    (memory.fill (global.get $anagramLetterCount) (i32.const 0) (i32.const 26))
    (loop $chars
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $pos))))
      (if (i32.eq (local.get $char) (global.get $lineBreak)) (then
        (if (local.get $start) (then 
          (local.set $length (i32.const -1))
          (loop $compare 
            (local.set $length (i32.add (local.get $length) (i32.const 1)))
          (br_if $compare (i32.and (i32.eq 
            (i32.load8_u (i32.add (global.get $wordLetterCount) (local.get $length)))
            (i32.load8_u (i32.add (global.get $anagramLetterCount) (local.get $length))))
            (i32.lt_u (local.get $length) (i32.const 26)))))
          (if (i32.eq (local.get $length (i32.const 26))) (then
            (local.set $length (i32.sub (i32.add (local.get $pos) (i32.const 1)) (local.get $start)))
            (if (i32.gt_u (local.get $length) (i32.const 1)) (then
              (local.set $char (i32.const 0))
              (loop $notEqual
                (local.set $char (i32.add (local.get $char) (i32.const 1)))
              (br_if $notEqual (i32.and (i32.lt_u (local.get $char) (local.get $length)) 
                (i32.eq (i32.or (i32.load8_u (i32.add (local.get $inputOffset) (local.get $char)))
                  (global.get $toLower))
                (i32.or (i32.load8_u (i32.add (i32.add (local.get $inputOffset) (local.get $start))
                    (local.get $char))) (global.get $toLower))))))
              (if (i32.ne (local.get $char) (local.get $length)) (then 
                (memory.copy (i32.add (global.get $outputOffset) (local.get $outputLength))
                (i32.add (local.get $inputOffset) (local.get $start)) (local.get $length))
              (local.set $outputLength (i32.add (local.get $outputLength) (local.get $length)))))))))))
        (memory.fill (global.get $anagramLetterCount) (i32.const 0) (i32.const 26))
        (local.set $start (i32.add (local.get $pos) (i32.const 1)))
      ) (else
        (local.set $char (i32.or (local.get $char) (global.get $toLower))) 
        (if (i32.and (i32.ge_u (local.get $char) (global.get $a))
          (i32.le_u (local.get $char) (global.get $z))) (then
          (local.set $length (i32.add (select (global.get $anagramLetterCount) (global.get $wordLetterCount)
            (local.get $start)) (i32.sub (local.get $char) (global.get $a))))
          (i32.store8 (local.get $length) (i32.add (i32.load8_u (local.get $length)) (i32.const 1)))
        ))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $pos) (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)