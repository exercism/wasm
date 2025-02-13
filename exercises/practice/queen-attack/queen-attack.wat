

(module
  (memory (export "mem") 1)

  ;;
  ;; Checks a queen positioning for validity and the ability to attack
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {i32} -1 if invalid, 0 if cannot attack, 1 if it can attack
  ;;
  (func (export "canAttack") (param $positions i32) (result i32)
    (i32.const -1)
  )

  ;;
  ;; Prints the chess board to linear memory (or return empty string if invalid)
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {(i32,i32)} offset and length of chess board string in memory
  ;;
  (func (export "printBoard") (param $positions i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
