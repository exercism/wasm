(module
  (memory (export "mem") 1)

  (global $PAREN_OPEN i32 (i32.const 40))
  (global $PAREN_CLOSE i32 (i32.const 41))
  (global $SQUARE_OPEN i32 (i32.const 91))
  (global $SQUARE_CLOSE i32 (i32.const 93))
  (global $CURLY_OPEN i32 (i32.const 123))
  (global $CURLY_CLOSE i32 (i32.const 125))

  (global $stackStart (mut i32) (i32.const 0))
  (global $stackEnd (mut i32) (i32.const 0))

  (func $initBracketStack (param $location i32)
    (global.set $stackStart (local.get $location))
    (global.set $stackEnd (local.get $location))
  )

  (func $push (param $bracket i32)
    (i32.store8 (global.get $stackEnd) (local.get $bracket))
    (global.set $stackEnd
      (i32.add
        (global.get $stackEnd)
        (i32.const 1)
      )
    )
  )

  (func $checkTop (param $required i32) (result i32)
    (if
      (i32.gt_u
        (global.get $stackEnd)
        (global.get $stackStart)
      )
      (then
        (global.set
          $stackEnd
          (i32.sub
            (global.get $stackEnd)
            (i32.const 1)
          )
        )

        (return
          (i32.eq
            (i32.load8_u (global.get $stackEnd))
            (local.get $required)
          )
        )
      )
    )
    (return (i32.const 0))
  )

  ;; Determines of the brackets in a string is balanced.
  ;;
  ;; @param {i32} text - the offset where the text string begins in memory
  ;; @param {i32} length - the length of the text
  ;;
  ;; @returns {i32} 1 if brackets are in pairs, 0 otherwise
  ;;
  (func (export "isPaired") (param $text i32) (param $length i32) (result i32)
    (local $char i32)

    (if (i32.eq (local.get $length) (i32.const 0))
      (then
        (return (i32.const 1))
      )
    )

    ;; Reuse the input string space to store info about the brackets.
    (call $initBracketStack (local.get $text))

    (block $checkBlock
      (loop $checkLoop
        (local.set $char (i32.load8_u (local.get $text)))
        (if
          (i32.or
            (i32.or
              (i32.eq (local.get $char) (global.get $PAREN_OPEN))
              (i32.eq (local.get $char) (global.get $SQUARE_OPEN))
            )
            (i32.eq (local.get $char) (global.get $CURLY_OPEN))
          )
          (then
            (call $push (local.get $char))
          )
        )

        (if
          (i32.eq (local.get $char) (global.get $PAREN_CLOSE))
          (then
            (if
              (i32.eq (call $checkTop (global.get $PAREN_OPEN)) (i32.const 0))
              (then
                (return (i32.const 0))
              )
            )
          )
        )

        (if
          (i32.eq (local.get $char) (global.get $SQUARE_CLOSE))
          (then
            (if
              (i32.eq (call $checkTop (global.get $SQUARE_OPEN)) (i32.const 0))
              (then
                (return (i32.const 0))
              )
            )
          )
        )

        (if
          (i32.eq (local.get $char) (global.get $CURLY_CLOSE))
          (then
            (if
              (i32.eq (call $checkTop (global.get $CURLY_OPEN)) (i32.const 0))
              (then
                (return (i32.const 0))
              )
            )
          )
        )

        (local.set
          $length
          (i32.sub
            (local.get $length)
            (i32.const 1)
          )
        )

        (local.set
          $text
          (i32.add
            (local.get $text)
            (i32.const 1)
          )
        )

        (br_if
          $checkLoop
          (i32.gt_u (local.get $length) (i32.const 0))
        )
      )
    )

    (return
      (i32.eq
        (global.get $stackStart)
        (global.get $stackEnd)
      )
    )
  )
)
