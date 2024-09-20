(module
  (memory (export "mem") 1)

  (global $SPACE i32 (i32.const 32))
  (global $ZERO i32 (i32.const 48))
  (global $A i32 (i32.const 97))
  (global $Z i32 (i32.const 122))

   (func $process (param $offset i32) (param $length i32) (param $chunk i32) (result i32 i32)
    (local $source i32)
    (local $dest i32)
    (local $stop i32)
    (local $value i32)
    (local $digit i32)
    (local $letter i32)
    (local $count i32)

    (local.set $source (local.get $offset))
    (local.set $stop (i32.add (local.get $offset) (local.get $length)))
    (local.set $dest (local.get $stop))
    (local.set $count (i32.const 5))

    (loop $read
      (if (i32.lt_u (local.get $source) (local.get $stop)) (then
        (local.set $value (i32.load8_u (local.get $source)))
        (local.set $source (i32.add (local.get $source) (i32.const 1)))
        (local.set $digit (i32.sub (local.get $value) (global.get $ZERO)))
        (local.set $letter
          (i32.sub
            (i32.or (local.get $value) (i32.const 32))
            (global.get $A)
          )
        )

        (if (i32.ge_u (local.get $digit) (i32.const 10)) (then
          (br_if $read (i32.ge_u (local.get $letter) (i32.const 26)))
          (local.set $value (i32.sub (global.get $Z) (local.get $letter)))
        ))

        (if (local.get $chunk) (then
          (if (i32.eq (local.get $count) (i32.const 0)) (then
            (i32.store (local.get $dest) (global.get $SPACE))
            (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
            (local.set $count (i32.const 5))
          ))
          (local.set $count (i32.sub (local.get $count) (i32.const 1)))
        ))

        (i32.store (local.get $dest) (local.get $value))
        (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
        (br $read)
      ))
    )

    (return (local.get $stop)
            (i32.sub (local.get $dest) (local.get $stop))
    )
  )

  ;;
  ;; Encode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $offset i32) (param $length i32) (result i32 i32)
    (return (call $process (local.get $offset) (local.get $length) (i32.const 1)))
  )

  ;;
  ;; Decode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $offset i32) (param $length i32) (result i32 i32)
    (return (call $process (local.get $offset) (local.get $length) (i32.const 0)))
  )
)
