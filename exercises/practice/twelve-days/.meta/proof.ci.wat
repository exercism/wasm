(module
  (memory (export "mem") 1)

  (data (i32.const 0) "On the ")

  (data (i32.const 10) "firstsecondthirdfourthfifthsixthseventheighthninthtentheleventhtwelfth")

  ;; 16 bit offsets [0, 0, 5, 11, 16, 22, 27, 32, 39, 45, 50, 55, 63, 70]
  (data (i32.const 80) "\00\00\00\00\05\00\0b\00\10\00\16\00\1b\00\20\00\27\00\2d\00\32\00\37\00\3f\00\46\00\46\00")

  (data (i32.const 110) " day of Christmas my true love gave to me: ")

  (data (i32.const 160) "twelve Drummers Drumming, eleven Pipers Piping, ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.\n")

  ;; 16 bit offsets [0, 235, 213, 194, 174, 157, 137, 113, 90, 69, 48, 26, 0]
  (data (i32.const 430) "\00\00\eb\00\d5\00\c2\00\ae\00\9d\00\89\00\71\00\5a\00\45\00\30\00\1a\00\00\00")

  (global $ON_THE_OFFSET i32 (i32.const 0))

  (global $ON_THE_LENGTH i32 (i32.const 7))

  (global $ORDINALS_OFFSET i32 (i32.const 10))

  (global $ORDINALS_TABLE_OFFSET i32 (i32.const 80))

  (global $DAY_OF_OFFSET i32 (i32.const 110))

  (global $DAY_OF_LENGTH i32 (i32.const 43))

  (global $GIFTS_OFFSET i32 (i32.const 160))

  (global $GIFTS_LENGTH i32 (i32.const 263))

  (global $GIFTS_TABLE_OFFSET i32 (i32.const 430))

  (global $OUTPUT i32 (i32.const 460))

  ;;
  ;; Lyrics to 'The Twelve Days of Christmas'.
  ;;
  ;; @param {i32} startVerse - The initial reverse to recite
  ;; @param {i32} endVerse - The final reverse to recite
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startVerse i32) (param $endVerse i32) (result i32 i32)
    (local $dest i32)
    (local $verse i32)
    (local $offset i32)
    (local $length i32)

    (local.set $dest (global.get $OUTPUT))
    (local.set $verse (local.get $startVerse))

    (loop $LOOP
      (memory.copy (local.get $dest)
                   (global.get $ON_THE_OFFSET)
                   (global.get $ON_THE_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $ON_THE_LENGTH)))

      (local.set $offset (i32.add (global.get $ORDINALS_TABLE_OFFSET)
                                  (i32.shl (local.get $verse) (i32.const 1))))
      (local.set $length (i32.load16_u (i32.add (local.get $offset)
                                                (i32.const 2))))
      (local.set $offset (i32.load16_u (local.get $offset)))
      (local.set $length (i32.sub (local.get $length)
                                  (local.get $offset)))
      (memory.copy (local.get $dest)
                   (i32.add (local.get $offset) (global.get $ORDINALS_OFFSET))
                   (local.get $length))
      (local.set $dest (i32.add (local.get $dest)
                                (local.get $length)))

      (memory.copy (local.get $dest)
                   (global.get $DAY_OF_OFFSET)
                   (global.get $DAY_OF_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $DAY_OF_LENGTH)))

      (local.set $offset (i32.load16_u (i32.add (global.get $GIFTS_TABLE_OFFSET)
                                                (i32.shl (local.get $verse) (i32.const 1)))))
      (local.set $length (i32.sub (global.get $GIFTS_LENGTH)
                                  (local.get $offset)))
      (memory.copy (local.get $dest)
                   (i32.add (local.get $offset) (global.get $GIFTS_OFFSET))
                   (local.get $length))
      (local.set $dest (i32.add (local.get $dest)
                                (local.get $length)))

      (local.set $verse (i32.add (local.get $verse)
                                 (i32.const 1)))
      (br_if $LOOP (i32.le_u (local.get $verse)
                             (local.get $endVerse)))
    )

    (return (global.get $OUTPUT) (i32.sub (local.get $dest)
                                          (global.get $OUTPUT)))
  )
)
