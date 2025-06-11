(module
  (memory (export "mem") 1)

  (data (i32.const 0) "For want of a ")

  (data (i32.const 20) " the ")

  (data (i32.const 30) " was lost.\n")

  (data (i32.const 50) "And all for the want of a ")

  (data (i32.const 80) ".\n")

  (global $NEWLINE i32 (i32.const 10))

  (global $FOR_WANT_OFFSET i32 (i32.const 0))

  (global $FOR_WANT_LENGTH i32 (i32.const 14))

  (global $THE_OFFSET i32 (i32.const 20))

  (global $THE_LENGTH i32 (i32.const 5))

  (global $WAS_LOST_OFFSET i32 (i32.const 30))

  (global $WAS_LOST_LENGTH i32 (i32.const 11))

  (global $AND_ALL_OFFSET i32 (i32.const 50))

  (global $AND_ALL_LENGTH i32 (i32.const 26))

  (global $STOP_OFFSET i32 (i32.const 80))

  (global $STOP_LENGTH i32 (i32.const 2))

  (global $OUTPUT i32 (i32.const 400))

  (func $scan (param $offset i32) (result i32)
    (local $ch i32)
    (loop $LOOP
      (local.set $ch (i32.load8_u (local.get $offset)))
      (local.set $offset (i32.add (local.get $offset)
                                  (i32.const 1)))
      (br_if $LOOP (i32.ne (local.get $ch) (global.get $NEWLINE)))
    )
    (return (local.get $offset))
  )

  (func $append (param $destination i32) (param $source i32) (param $length i32) (result i32)
    (memory.copy (local.get $destination)
                 (local.get $source)
                 (local.get $length))
    (return (i32.add (local.get $destination)
                     (local.get $length)))
  )

  ;;
  ;; The full text of the proverbial rhyme.
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $offset i32) (param $length i32) (result i32 i32)
    (local $dest i32)
    (local $current i32)
    (local $first i32)
    (local $next i32)
    (local $second i32)
    (local $stop i32)
    (local $len i32)

    (if (i32.eqz (local.get $length)) (then
      (return (i32.const 0) (i32.const 0))
    ))

    (local.set $dest (global.get $OUTPUT))

    (local.set $current (local.get $offset))
    (local.set $first (local.get $offset))

    (local.set $next (call $scan (local.get $current)))
    (local.set $second (local.get $next))

    (local.set $stop (i32.add (local.get $offset)
                              (local.get $length)))

    (loop $LOOP
      (if (i32.ne (local.get $next) (local.get $stop)) (then
        ;; "For want of a "
        (local.set $dest (call $append (local.get $dest)
                                       (global.get $FOR_WANT_OFFSET)
                                       (global.get $FOR_WANT_LENGTH)))

        (local.set $len (i32.sub (i32.sub (local.get $next)
                                          (i32.const 1))
                                 (local.get $current)))
        (local.set $dest (call $append (local.get $dest)
                                       (local.get $current)
                                       (local.get $len)))

        (local.set $current (local.get $next))
        (local.set $next (call $scan (local.get $current)))

        ;; " the "
        (local.set $dest (call $append (local.get $dest)
                                       (global.get $THE_OFFSET)
                                       (global.get $THE_LENGTH)))

        (local.set $len (i32.sub (i32.sub (local.get $next)
                                          (i32.const 1))
                                 (local.get $current)))
        (local.set $dest (call $append (local.get $dest)
                                       (local.get $current)
                                       (local.get $len)))

        ;; " was lost.\n"
        (local.set $dest (call $append (local.get $dest)
                                       (global.get $WAS_LOST_OFFSET)
                                       (global.get $WAS_LOST_LENGTH)))

        (br $LOOP)
      ))
    )

    ;; "And all for the want of a "
    (local.set $dest (call $append (local.get $dest)
                                   (global.get $AND_ALL_OFFSET)
                                   (global.get $AND_ALL_LENGTH)))

    (local.set $len (i32.sub (i32.sub (local.get $second)
                                      (i32.const 1))
                             (local.get $first)))
    (local.set $dest (call $append (local.get $dest)
                                   (local.get $first)
                                   (local.get $len)))

    ;; ".\n"
    (local.set $dest (call $append (local.get $dest)
                                   (global.get $STOP_OFFSET)
                                   (global.get $STOP_LENGTH)))

    (return (global.get $OUTPUT) (i32.sub (local.get $dest)
                                          (global.get $OUTPUT)))
  )
)
