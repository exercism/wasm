(module
  (memory (export "mem") 1)

  (global $parentTable i32 (i32.const 0))

  (global $tallyTable i32 (i32.const 16))

  (func $root (param $nibble i32) (result i32)
    (local $current i32)
    (local $parent i32)
    (local.set $parent (local.get $nibble))

    (loop $traverse
      (local.set $current (local.get $parent))
      (local.set $parent (i32.load8_u (i32.add (global.get $parentTable)
                                               (local.get $current))))
      (br_if $traverse (i32.ne (local.get $parent)
                               (local.get $current)))
    )

    (return (local.get $current))
  )

  (func $updateTally (param $nibble i32)
    (local $ptr i32)

    (local.set $ptr (i32.add (global.get $tallyTable)
                             (local.get $nibble)))
    (i32.store8 (local.get $ptr)
                (i32.add (i32.const 1)
                         (i32.load8_u (local.get $ptr))))
  )

  ;;
  ;; Determine if the dominoes form a chain.
  ;;
  ;; @param {i32} offset - offset of byte array in linear memory
  ;; @param {i32} length - length of byte array in linear memory
  ;;
  ;; @returns {i32} 1 if the dominoes form a chain, 0 otherwise
  ;;
  (func (export "canChain") (param $offset i32) (param $length i32) (result i32)
    (local $i i32)
    (local $stone i32)
    (local $left i32)
    (local $right i32)
    (local $roots i32)
    (local $tally i32)

    (if (i32.eqz (local.get $length)) (then 
      (return (i32.const 1))
    ))

    (memory.fill (global.get $tallyTable) (i32.const 0) (i32.const 16))

    (local.set $i (i32.const 0))
    (loop $init
      (i32.store8 (i32.add (global.get $parentTable)
                           (local.get $i))
                  (local.get $i))
      (local.set $i (i32.add (local.get $i)
                             (i32.const 1)))
      (br_if $init (i32.lt_u (local.get $i)
                             (i32.const 16)))
    )

    (loop $read
      (local.set $stone (i32.load8_u (local.get $offset)))
      (local.set $offset (i32.add (local.get $offset)
                                  (i32.const 1)))
      (local.set $length (i32.sub (local.get $length)
                                  (i32.const 1)))

      (local.set $left (i32.shr_u (local.get $stone)
                                  (i32.const 4)))
      (local.set $right (i32.and (local.get $stone)
                                 (i32.const 15)))

      (call $updateTally (local.get $left))
      (call $updateTally (local.get $right))

      (local.set $left (call $root (local.get $left)))
      (local.set $right (call $root (local.get $right)))

      (i32.store8 (i32.add (global.get $parentTable)
                           (local.get $left))
                  (local.get $right))

      (br_if $read (local.get $length))
    )

    (local.set $roots (i32.const 0))
    (local.set $i (i32.const 0))
    (loop $count
      (local.set $tally (i32.load8_u (i32.add (global.get $tallyTable)
                                              (local.get $i))))
      (if (local.get $tally) (then
        (if (i32.and (local.get $tally)
                     (i32.const 1)) (then
          (return (i32.const 0)
        )))

        (if (i32.eq (local.get $i)
                    (i32.load8_u (i32.add (global.get $parentTable)
                                          (local.get $i)))) (then
          (local.set $roots (i32.add (local.get $roots)
                                     (i32.const 1)))
        ))
      ))

      (local.set $i (i32.add (local.get $i)
                             (i32.const 1)))
      (br_if $count (i32.lt_u (local.get $i)
                              (i32.const 16)))
    )

    (return (i32.eq (local.get $roots)
                    (i32.const 1)))
  )
)
