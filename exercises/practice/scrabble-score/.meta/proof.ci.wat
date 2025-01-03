(module
  (memory (export "mem") 1)

  ;; ':' is the ASCII character after '9' and indicates a letter score of 10.
  (data (i32.const 0) "1332142418513113:11114484:")

  (global $ZERO i32 (i32.const 48))
  (global $A i32 (i32.const 65))

  ;;
  ;; Given a word, compute the Scrabble score for that word
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {i32} - the computed score
  ;;
  (func (export "score") (param $offset i32) (param $len i32) (result i32)
    (local $source i32)
    (local $result i32)
    (local $letter i32)

    (local.set $source (i32.add (local.get $offset)
                                (local.get $len)))
    (local.set $result (i32.const 0))

    (loop $body
      (if (i32.ne (local.get $source) (local.get $offset)) (then
        (local.set $source (i32.sub (local.get $source)
                                    (i32.const 1)))
        (local.set $letter (i32.sub (i32.and (i32.load8_u (local.get $source))
                                             (i32.const -33))
                                    (global.get $A)))
        (if (i32.lt_u (local.get $letter) (i32.const 26)) (then
          (local.set $result (i32.add (local.get $result)
                                      (i32.sub (i32.load8_u (local.get $letter))
                                               (global.get $ZERO))))
        ))
        (br $body)
      ))
    )
    (return (local.get $result))
  )
)
