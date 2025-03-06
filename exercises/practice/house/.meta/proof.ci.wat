(module
  (memory (export "mem") 1)

  (data (i32.const 0) "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n")

  ;; 16 bit offsets [ 0, 389, 368, 351, 331, 310, 267, 232, 190, 145, 99, 62, 8 ]
  (data (i32.const 500) "\00\00\85\01\70\01\5f\01\4b\01\36\01\0b\01\e8\00\be\00\91\00\63\00\3e\00\08\00")

  (global $LYRICS_LENGTH i32 (i32.const 416))

  (global $PREFIX_LENGTH i32 (i32.const 8))

  (global $TABLE i32 (i32.const 500))

  (global $OUTPUT i32 (i32.const 600))

  ;;
  ;; Lyrics to 'This is the House that Jack Built'.
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
    (local $offset i32)
    (local $length i32)

    (local.set $dest (global.get $OUTPUT))
    (local.set $verse (local.get $startVerse))

    (loop $LOOP
      (memory.copy (local.get $dest)
                   (i32.const 0)
                   (global.get $PREFIX_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $PREFIX_LENGTH)))

      (local.set $offset (i32.load16_u (i32.add (global.get $TABLE)
                                                (i32.shl (local.get $verse) (i32.const 1)))))
      (local.set $length (i32.sub (global.get $LYRICS_LENGTH)
                                  (local.get $offset)))
      (memory.copy (local.get $dest)
                   (local.get $offset)
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
