(module
  (memory (export "mem") 1)

  (global $NEWLINE i32 (i32.const 10))

  (global $MINE i32 (i32.const 42))

  (global $ZERO i32 (i32.const 48))

  ;;
  ;; Adds numbers to a minesweeper board.
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the output string in linear memory
  ;;
  (func (export "annotate") (param $offset i32) (param $length i32) (result i32 i32)

    (local $stop i32)
    (local $lineLength i32) ;; including newline character
    (local $index i32)
    (local $char i32)
    (local $mineCount i32)

    (local $previousRow i32)
    (local $currentRow i32)
    (local $nextRow i32)
    (local $adjacentRow i32)

    (local $previousColumn i32)
    (local $currentColumn i32)
    (local $nextColumn i32)
    (local $adjacentColumn i32)

    (if (i32.eq (local.get $length) (i32.const 0)) (then
      ;; no rows
      (return (local.get $offset) (local.get $length))
    ))

    (local.set $stop (i32.add (local.get $offset) (local.get $length)))
    (local.set $index (local.get $offset))
    (loop
      (local.set $char (i32.load8_u (local.get $index)))
      (local.set $index (i32.add (local.get $index) (i32.const 1)))
      (br_if 0 (i32.ne (local.get $char) (global.get $NEWLINE)))
    )
    (local.set $lineLength (i32.sub (local.get $index) (local.get $offset)))
    (if (i32.eq (local.get $lineLength) (i32.const 1)) (then
      ;; each row has newline only
      (return (local.get $offset) (local.get $length))
    ))

    (local.set $currentRow (local.get $offset))
    (local.set $nextRow (local.get $offset)) ;; start of first row

    (loop $eachCurrentRow
      (local.set $previousRow (local.get $currentRow)) ;; current row becomes previous row
      (local.set $currentRow (local.get $nextRow)) ;; next row becomes current row
      (local.set $nextRow (i32.add (local.get $currentRow) (local.get $lineLength)))
      (if (i32.eq (local.get $nextRow) (local.get $stop)) (then
        (local.set $nextRow (local.get $currentRow)) ;; last row
      ))

      (local.set $currentColumn (i32.const 0))
      (local.set $nextColumn (i32.const 0)) ;; first column

      (loop $eachCurrentColumn
        (local.set $previousColumn (local.get $currentColumn)) ;; current column becomes previous column
        (local.set $currentColumn (local.get $nextColumn)) ;; next column becomes current column
        (if (i32.ne (i32.add (local.get $nextColumn) (i32.const 2))
                    (local.get $lineLength)) (then
          (local.set $nextColumn (i32.add (local.get $currentColumn) (i32.const 1)))
        ))

        (local.set $index (i32.add (local.get $currentRow) (local.get $currentColumn))) ;; address of minefield square
        (local.set $char (i32.load8_u (local.get $index)))
        (if (i32.ne (local.get $char) (global.get $MINE)) (then
          (local.set $mineCount (i32.const 0)) ;; number of adjacent mines

          (local.set $adjacentRow (i32.sub (local.get $previousRow) (local.get $lineLength)))
          (loop $eachAdjacentRow
            ;; address of adjacent row: $previousRow, $previousRow+$lineLength, $nextRow
            (local.set $adjacentRow (i32.add (local.get $adjacentRow) (local.get $lineLength)))

            (local.set $adjacentColumn (i32.sub (local.get $previousColumn) (i32.const 1)))
            (loop $eachAdjacentColumn
              ;; index of adjacent column in row: $previousColumn, $previousColumn+1, $nextColumn
              (local.set $adjacentColumn (i32.add (local.get $adjacentColumn) (i32.const 1)))

              ;; content of adjacent square
              (local.set $char (i32.load8_u (i32.add (local.get $adjacentRow)
                                                     (local.get $adjacentColumn))))
              ;; increment mineCount if square contains mine
              (local.set $mineCount (i32.add (local.get $mineCount)
                                             (i32.eq (local.get $char) (global.get $MINE))))
              (br_if $eachAdjacentColumn (i32.ne (local.get $adjacentColumn) (local.get $nextColumn)))
            )

            (br_if $eachAdjacentRow (i32.ne (local.get $adjacentRow) (local.get $nextRow)))
          )

          (if (local.get $mineCount) (then
            (i32.store8 (local.get $index) (i32.add (global.get $ZERO) (local.get $mineCount)))
          ))
        ))

        (br_if $eachCurrentColumn (i32.ne (local.get $currentColumn) (local.get $nextColumn)))
      )

      (br_if $eachCurrentRow (i32.ne (local.get $currentRow) (local.get $nextRow)))
    )

    (return (local.get $offset) (local.get $length))
  )
)
