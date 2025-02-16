(module
  (memory (export "mem") 2)
  (data (i32.const 0) "_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n")

  (global $White i32 (i32.const 87))
  (global $Black i32 (i32.const 66))

  ;;
  ;; Checks a queen positioning for validity and the ability to attack
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {i32} -1 if invalid, 0 if cannot attack, 1 if it can attack
  ;;
  (func $canAttack (export "canAttack") (param $positions i32) (result i32)
    ;; any position > 7
    (if (i32.or (i32.and (local.get $positions) (i32.const 4177066232))
      ;; identical positions
      (i32.eqz (i32.xor (i32.shr_u (local.get $positions) (i32.const 16))
      (i32.and (local.get $positions) (i32.const 65535)))))
        (then (return (i32.const -1))))
    ;; horizontal
    (i32.or (i32.or (i32.eq (i32.and (local.get $positions) (i32.const 255))
      (i32.and (i32.shr_u (local.get $positions) (i32.const 16)) (i32.const 255)))
      ;; vertical
      (i32.eq (i32.and (i32.shr_u (local.get $positions) (i32.const 8)) (i32.const 255))
      (i32.and (i32.shr_u (local.get $positions) (i32.const 24)) (i32.const 255))))
      ;; diagonal
      (f32.eq (f32.abs (f32.convert_i32_s (i32.sub 
        (i32.and (local.get $positions) (i32.const 255))
        (i32.and (i32.shr_u (local.get $positions) (i32.const 16)) (i32.const 255)))))
      (f32.abs (f32.convert_i32_s (i32.sub 
        (i32.and (i32.shr_u (local.get $positions) (i32.const 8)) (i32.const 255))
        (i32.and (i32.shr_u (local.get $positions) (i32.const 24)) (i32.const 255)))))))
  )

  ;;
  ;; Prints the chess board to linear memory
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {(i32,i32)} offset and length of chess board string in memory
  ;;
  (func (export "printBoard") (param $positions i32) (result i32 i32)
    (i32.store8 (i32.or 
      (i32.shl (i32.and (i32.shr_u (local.get $positions)
        (i32.const 16)) (i32.const 7)) (i32.const 1))
      (i32.shl (i32.and (i32.shr_u (local.get $positions)
        (i32.const 24)) (i32.const 7)) (i32.const 4)))
      (global.get $White))
    (i32.store8 (i32.or 
      (i32.shl (i32.and (local.get $positions) (i32.const 7)) (i32.const 1))
      (i32.shl (i32.and (i32.shr_u (local.get $positions) (i32.const 8))
        (i32.const 7)) (i32.const 4)))
      (global.get $Black))
    (i32.const 0) (i32.const 128)
  )
)
