(module
  (memory (export "mem") 1)

  (data (i32.const 0) "I know an old lady who swallowed a ")

  (data (i32.const 40) "flyspiderbirdcatdoggoatcowhorse")

  ;; 8 bit offsets [0, 0, 3, 9, 13, 16, 19, 23, 26, 31, 31]
  (data (i32.const 80) "\00\00\03\09\0d\10\13\17\1a\1f\1f")

  (data (i32.const 100) ".\n")

  (data (i32.const 110) "I don't know why she swallowed the fly. Perhaps she'll die.\nIt wriggled and jiggled and tickled inside her.\nHow absurd to swallow a bird!\nImagine that, to swallow a cat!\nWhat a hog, to swallow a dog!\nJust opened her throat and swallowed a goat!\nI don't know how she swallowed a cow!\nShe's dead, of course!\n")

  ;; 16 bit offsets [0, 0, 60, 108, 138, 170, 200, 245, 283, 306]
  (data (i32.const 420) "\00\00\00\00\3c\00\6c\00\8a\00\aa\00\c8\00\f5\00\1b\01\32\01")

  (data (i32.const 450) "She swallowed the ")

  (data (i32.const 470) " to catch the ")

  (data (i32.const 490) " that wriggled and jiggled and tickled inside her")

  (global $NEWLINE i32 (i32.const 10))

  (global $I_KNOW_OFFSET i32 (i32.const 0))

  (global $I_KNOW_LENGTH i32 (i32.const 35))

  (global $ANIMALS_OFFSET i32 (i32.const 40))

  (global $ANIMALS_TABLE_OFFSET i32 (i32.const 80))

  (global $STOP_OFFSET i32 (i32.const 100))

  (global $STOP_LENGTH i32 (i32.const 2))

  (global $EXCLAMATIONS_OFFSET i32 (i32.const 110))

  (global $EXCLAMATIONS_TABLE_OFFSET i32 (i32.const 420))

  (global $SHE_SWALLOWED_OFFSET i32 (i32.const 450))

  (global $SHE_SWALLOWED_LENGTH i32 (i32.const 18))

  (global $TO_CATCH_OFFSET i32 (i32.const 470))

  (global $TO_CATCH_LENGTH i32 (i32.const 14))

  (global $THAT_WRIGGLED_OFFSET i32 (i32.const 490))

  (global $THAT_WRIGGLED_LENGTH i32 (i32.const 49))

  (global $OUTPUT i32 (i32.const 600))

  ;;
  ;; Lyrics to 'I Know an Old Lady Who Swallowed a Fly'.
  ;;
  ;; @param {i32} startVerse - The initial verse to recite
  ;; @param {i32} endVerse - The final verse to recite
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startVerse i32) (param $endVerse i32) (result i32 i32)
    (local $dest i32)
    (local $verse i32)
    (local $animal i32)
    (local $offset i32)
    (local $length i32)

    (local.set $dest (global.get $OUTPUT))
    (local.set $verse (local.get $startVerse))

    (loop $OUTER
      (if (i32.ne (local.get $verse) (local.get $startVerse)) (then
        ;; newline between verses
        (i32.store8 (local.get $dest) (global.get $NEWLINE))
        (local.set $dest (i32.add (local.get $dest)
                                  (i32.const 1)))
      ))

      ;; "I know an old lady who swallowed a "
      (memory.copy (local.get $dest)
                   (global.get $I_KNOW_OFFSET)
                   (global.get $I_KNOW_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $I_KNOW_LENGTH)))

      ;; "fly", ...
      (local.set $offset (i32.add (global.get $ANIMALS_TABLE_OFFSET)
                                  (local.get $verse)))
      (local.set $length (i32.load8_u (i32.add (local.get $offset)
                                               (i32.const 1))))
      (local.set $offset (i32.load8_u (local.get $offset)))
      (local.set $length (i32.sub (local.get $length)
                                  (local.get $offset)))
      (memory.copy (local.get $dest)
                   (i32.add (local.get $offset) (global.get $ANIMALS_OFFSET))
                   (local.get $length))
      (local.set $dest (i32.add (local.get $dest)
                                (local.get $length)))

      ;; ".\n"
      (memory.copy (local.get $dest)
                   (global.get $STOP_OFFSET)
                   (global.get $STOP_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $STOP_LENGTH)))

      ;; I don't know why she swallowed the fly. Perhaps she'll die.\n", ...
      (local.set $offset (i32.add (global.get $EXCLAMATIONS_TABLE_OFFSET)
                                  (i32.shl (local.get $verse) (i32.const 1))))
      (local.set $length (i32.load16_u (i32.add (local.get $offset)
                                                (i32.const 2))))
      (local.set $offset (i32.load16_u (local.get $offset)))
      (local.set $length (i32.sub (local.get $length)
                                  (local.get $offset)))
      (memory.copy (local.get $dest)
                   (i32.add (local.get $offset) (global.get $EXCLAMATIONS_OFFSET))
                   (local.get $length))
      (local.set $dest (i32.add (local.get $dest)
                                (local.get $length)))

      (if (i32.and (i32.gt_u (local.get $verse) (i32.const 1))
                   (i32.lt_u (local.get $verse) (i32.const 8))) (then
        (local.set $animal (local.get $verse))

        (loop $INNER
          ;; "She swallowed the "
          (memory.copy (local.get $dest)
                       (global.get $SHE_SWALLOWED_OFFSET)
                       (global.get $SHE_SWALLOWED_LENGTH))
          (local.set $dest (i32.add (local.get $dest)
                                    (global.get $SHE_SWALLOWED_LENGTH)))

          ;; "spider", ...
          (local.set $offset (i32.add (global.get $ANIMALS_TABLE_OFFSET)
                                      (local.get $animal)))
          (local.set $length (i32.load8_u (i32.add (local.get $offset)
                                                   (i32.const 1))))
          (local.set $offset (i32.load8_u (local.get $offset)))
          (local.set $length (i32.sub (local.get $length)
                                      (local.get $offset)))
          (memory.copy (local.get $dest)
                       (i32.add (local.get $offset) (global.get $ANIMALS_OFFSET))
                       (local.get $length))
          (local.set $dest (i32.add (local.get $dest)
                                    (local.get $length)))

          ;; " to catch the "
          (memory.copy (local.get $dest)
                       (global.get $TO_CATCH_OFFSET)
                       (global.get $TO_CATCH_LENGTH))
          (local.set $dest (i32.add (local.get $dest)
                                    (global.get $TO_CATCH_LENGTH)))

          (local.set $animal (i32.sub (local.get $animal)
                                      (i32.const 1)))

          ;; "fly", ...
          (local.set $offset (i32.add (global.get $ANIMALS_TABLE_OFFSET)
                                      (local.get $animal)))
          (local.set $length (i32.load8_u (i32.add (local.get $offset)
                                                   (i32.const 1))))
          (local.set $offset (i32.load8_u (local.get $offset)))
          (local.set $length (i32.sub (local.get $length)
                                      (local.get $offset)))
          (memory.copy (local.get $dest)
                       (i32.add (local.get $offset) (global.get $ANIMALS_OFFSET))
                       (local.get $length))
          (local.set $dest (i32.add (local.get $dest)
                                    (local.get $length)))

          (if (i32.eq (local.get $animal) (i32.const 2)) (then
            ;; " that wriggled and jiggled and tickled inside her"
            (memory.copy (local.get $dest)
                         (global.get $THAT_WRIGGLED_OFFSET)
                         (global.get $THAT_WRIGGLED_LENGTH))
            (local.set $dest (i32.add (local.get $dest)
                                      (global.get $THAT_WRIGGLED_LENGTH)))
          ))

          ;; ".\n"
          (memory.copy (local.get $dest)
                       (global.get $STOP_OFFSET)
                       (global.get $STOP_LENGTH))
          (local.set $dest (i32.add (local.get $dest)
                                    (global.get $STOP_LENGTH)))

          (br_if $INNER (i32.ne (local.get $animal) (i32.const 1)))
        )

        ;; I don't know why she swallowed the fly. Perhaps she'll die.\n"
        (local.set $offset (i32.add (global.get $EXCLAMATIONS_TABLE_OFFSET)
                                    (i32.shl (local.get $animal) (i32.const 1))))
        (local.set $length (i32.load16_u (i32.add (local.get $offset)
                                                  (i32.const 2))))
        (local.set $offset (i32.load16_u (local.get $offset)))
        (local.set $length (i32.sub (local.get $length)
                                    (local.get $offset)))
        (memory.copy (local.get $dest)
                     (i32.add (local.get $offset) (global.get $EXCLAMATIONS_OFFSET))
                     (local.get $length))
        (local.set $dest (i32.add (local.get $dest)
                                  (local.get $length)))
      ))

      (local.set $verse (i32.add (local.get $verse)
                                 (i32.const 1)))
      (br_if $OUTER (i32.le_u (local.get $verse)
                              (local.get $endVerse)))
    )

    (return (global.get $OUTPUT) (i32.sub (local.get $dest)
                                          (global.get $OUTPUT)))
  )
)
