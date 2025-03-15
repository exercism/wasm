(module
  (memory (export "mem") 1)

  (data (i32.const 0) "NoOneTwoThreeFourFiveSixSevenEightNineTen")

  ;; 8 bit offsets [0, 2, 5, 8, 13, 17, 21, 24, 29, 34, 38, 41]
  (data (i32.const 50) "\00\02\05\08\0d\11\15\18\1d\22\26\29")

  (data (i32.const 70) " green bottle")

  (data (i32.const 90) " hanging on the wall,\n")

  (data (i32.const 120) "And if one green bottle should accidentally fall,\nThere'll be ")

  (global $NUMBERS_OFFSET i32 (i32.const 0))

  (global $NUMBERS_TABLE_OFFSET i32 (i32.const 50))

  (global $GREEN_BOTTLE_OFFSET i32 (i32.const 70))

  (global $GREEN_BOTTLE_LENGTH i32 (i32.const 13))

  (global $HANGING_ON_OFFSET i32 (i32.const 90))

  (global $HANGING_ON_LENGTH i32 (i32.const 22))

  (global $AND_IF_OFFSET i32 (i32.const 120))

  (global $AND_IF_LENGTH i32 (i32.const 62))

  (global $OUTPUT i32 (i32.const 200))

  (global $NEWLINE i32 (i32.const 10))
  (global $PERIOD i32 (i32.const 46))
  (global $S i32 (i32.const 115))

  (func $reciteLine (param $bottles i32) (param $dest i32) (result i32)
    (local $offset i32)
    (local $length i32)

    (local.set $offset (i32.add (global.get $NUMBERS_TABLE_OFFSET)
                                (local.get $bottles)))
    (local.set $length (i32.load8_u (i32.add (local.get $offset)
                                             (i32.const 1))))
    (local.set $offset (i32.load8_u (local.get $offset)))
    (local.set $length (i32.sub (local.get $length)
                                (local.get $offset)))
    (memory.copy (local.get $dest)
                 (i32.add (local.get $offset) (global.get $NUMBERS_OFFSET))
                 (local.get $length))
    (local.set $dest (i32.add (local.get $dest)
                              (local.get $length)))

    (memory.copy (local.get $dest)
                 (global.get $GREEN_BOTTLE_OFFSET)
                 (global.get $GREEN_BOTTLE_LENGTH))
    (local.set $dest (i32.add (local.get $dest)
                              (global.get $GREEN_BOTTLE_LENGTH)))

    (if (i32.ne (local.get $bottles) (i32.const 1)) (then
      (i32.store8 (local.get $dest) (global.get $S))
      (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
    ))

    (memory.copy (local.get $dest)
                 (global.get $HANGING_ON_OFFSET)
                 (global.get $HANGING_ON_LENGTH))
    (local.set $dest (i32.add (local.get $dest)
                              (global.get $HANGING_ON_LENGTH)))

    (return (local.get $dest))
  )

  ;;
  ;; Lyrics to 'Ten Green Bottles'.
  ;;
  ;; @param {i32} startBottles - The initial number of bottles
  ;; @param {i32} takeDown - The number of bottles to be taken down
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startBottles i32) (param $takeDown i32) (result i32 i32)
    (local $stopBottles i32)
    (local $bottles i32)
    (local $savedDest i32)
    (local $dest i32)
    (local $offset i32)
    (local $length i32)

    (local.set $stopBottles (i32.sub (local.get $startBottles) (local.get $takeDown)))
    (local.set $bottles (local.get $startBottles))
    (local.set $dest (global.get $OUTPUT))

    (loop $LOOP
      (local.set $dest (call $reciteLine (local.get $bottles) (local.get $dest)))

      (local.set $dest (call $reciteLine (local.get $bottles) (local.get $dest)))

      (memory.copy (local.get $dest)
                   (global.get $AND_IF_OFFSET)
                   (global.get $AND_IF_LENGTH))
      (local.set $dest (i32.add (local.get $dest)
                                (global.get $AND_IF_LENGTH)))

      (local.set $bottles (i32.sub (local.get $bottles)
                                   (i32.const 1)))

      (local.set $savedDest (local.get $dest))

      (local.set $dest (call $reciteLine (local.get $bottles) (local.get $dest)))

      (i32.store8 (local.get $savedDest) (i32.or (i32.load8_u (local.get $savedDest)) (i32.const 32)))

      (i32.store8 (i32.sub (local.get $dest) (i32.const 2)) (global.get $PERIOD))

      (if (i32.ne (local.get $bottles) (local.get $stopBottles)) (then
        (i32.store8 (local.get $dest) (global.get $NEWLINE))
        (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
      ))

      (br_if $LOOP (i32.ne (local.get $bottles)
                           (local.get $stopBottles)))
    )

    (return (global.get $OUTPUT) (i32.sub (local.get $dest)
                                          (global.get $OUTPUT)))
  )
)
