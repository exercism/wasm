(module
    (memory (export "mem") 1)

    (global $error i32 (i32.const -1))
    (global $north i32 (i32.const 0))
    (global $east i32 (i32.const 1))
    (global $south i32 (i32.const 2))
    (global $west i32 (i32.const 3))

    ;;
    ;; evaluate robot placement after running instructions
    ;;
    ;; @param {i32} $direction - 0 = north, 1 = east, 2 = south, 3 = west
    ;; @param {i32} $x - horizontal position
    ;; @param {i32} $y - vertical position
    ;; @param {i32} $offset - the offset of the instructions in linear memory
    ;; @param {i32} $length - the length of the instructions in linear memory
    ;;
    ;; @returns {(i32,i32,i32)} direction, x and y after the instructions
    ;;          direction is -1 on error
    ;;
    (func (export "evaluate") (param $direction i32) (param $x i32) (param $y i32)
        (param $offset i32) (param $length i32) (result i32 i32 i32)
        (local.get $direction) (local.get $x) (local.get $y)
    )
)