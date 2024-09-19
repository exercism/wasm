(module
  (memory (export "mem") 1)

  (data (i32.const 400) "Sure.")
  (data (i32.const 410) "Whoa, chill out!")
  (data (i32.const 430) "Calm down, I know what I'm doing!")
  (data (i32.const 470) "Fine. Be that way!")
  (data (i32.const 490) "Whatever.")

  (global $SURE_OFFSET i32 (i32.const 400))
  (global $SURE_LENGTH i32 (i32.const 5))

  (global $WHOA_OFFSET i32 (i32.const 410))
  (global $WHOA_LENGTH i32 (i32.const 16))

  (global $CALM_OFFSET i32 (i32.const 430))
  (global $CALM_LENGTH i32 (i32.const 33))

  (global $FINE_OFFSET i32 (i32.const 470))
  (global $FINE_LENGTH i32 (i32.const 18))

  (global $WHATEVER_OFFSET i32 (i32.const 490))
  (global $WHATEVER_LENGTH i32 (i32.const 9))

  (global $SPACE i32 (i32.const 32))
  (global $QUESTION_MARK i32 (i32.const 63))
  (global $UPPER_A i32 (i32.const 65))
  (global $LOWER_A i32 (i32.const 97))

  ;;
  ;; Reply to someone when they say something or ask a question
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the reversed string in linear memory
  ;;
  (func (export "response") (param $offset i32) (param $length i32) (result i32 i32)
    (local $index i32)
    (local $stop i32)
    (local $value i32)
    (local $silence i32)
    (local $upper i32)
    (local $lower i32)
    (local $question i32)

    (local.set $index (local.get $offset))
    (local.set $stop (i32.add (local.get $offset) (local.get $length)))
    (local.set $silence (i32.const 1))
    (local.set $upper (i32.const 0))
    (local.set $lower (i32.const 0))
    (local.set $question (i32.const 0))

    (loop $read
      (if (i32.lt_u (local.get $index) (local.get $stop)) (then
        (local.set $value (i32.load8_u (local.get $index)))
        (local.set $index (i32.add (local.get $index) (i32.const 1)))
        (if (i32.gt_u (local.get $value) (global.get $SPACE)) (then
          (local.set $silence (i32.const 0))
          (local.set $question (i32.eq (local.get $value) (global.get $QUESTION_MARK)))
          (if (i32.lt_u (i32.sub (local.get $value) (global.get $UPPER_A)) (i32.const 26)) (then
            (local.set $upper (i32.const 1))
          ))
          (if (i32.lt_u (i32.sub (local.get $value) (global.get $LOWER_A)) (i32.const 26)) (then
            (local.set $lower (i32.const 1))
          ))
        ))
        (br $read)
      ))
    )

    (if (local.get $silence) (then
      (return (global.get $FINE_OFFSET) (global.get $FINE_LENGTH))
    ))

    (if (i32.eq (i32.sub (local.get $upper) (local.get $lower)) (i32.const 1)) (then
      (if (local.get $question) (then
        (return (global.get $CALM_OFFSET) (global.get $CALM_LENGTH))
      ))

      (return (global.get $WHOA_OFFSET) (global.get $WHOA_LENGTH))
    ))

    (if (local.get $question) (then
      (return (global.get $SURE_OFFSET) (global.get $SURE_LENGTH))
    ))

    (return (global.get $WHATEVER_OFFSET) (global.get $WHATEVER_LENGTH))
  )
)
