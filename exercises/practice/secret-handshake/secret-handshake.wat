(module
  (memory (export "mem") 1)

  ;;
  ;; compile a comma-separated list of commands to perform the secret handshake from the secret number
  ;;
  ;; @param {i32} number - the secret number that defines the handshake
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "commands") (param $number i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)