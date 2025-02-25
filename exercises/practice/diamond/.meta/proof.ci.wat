(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 0))
  (global $linebreak i32 (i32.const 10))
  (global $space i32 (i32.const 32))
  (global $A i32 (i32.const 65))

  ;;
  ;; Output a diamond made of letters with line breaks after each line.
  ;;
  ;; @param {i32} $letter - the character code of the letter in the middle of the diamond
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "rows") (param $letter i32) (result i32 i32)
    (local $size i32)
    (local $outputLength i32)
    (local $pos i32)
    (local $top i32)
    (local $bottom i32)
    (local $left i32)
    (local $right i32)
    ;; size of the diamond A = 1, B = 3, C = 5...
    (local.set $size (i32.add (i32.const -1) (i32.shl
      (i32.sub (local.get $letter) (i32.const 64)) (i32.const 1))))
    ;; fill grid with spaces
    (local.set $outputLength (i32.mul (local.get $size) (i32.add (local.get $size) (i32.const 1))))
    (memory.fill (global.get $outputOffset) (global.get $space) (local.get $outputLength))
    ;; add line breaks
    (local.set $pos (local.get $size))
    (loop $linebreaks
      (i32.store8 (i32.add (global.get $outputOffset) (local.get $pos)) (global.get $linebreak))
      (local.set $pos (i32.add (local.get $pos) (i32.add (local.get $size) (i32.const 1))))
    (br_if $linebreaks (i32.lt_u (local.get $pos) (local.get $outputLength))))
    ;; rows: letter - a, size - (letter - A)
    ;; cols: (size >> 1) +/- (letter - A)
    ;; start of a row (beginning with 0): row * (size + 1)
    (loop $lines
      (local.set $pos (i32.sub (local.get $letter) (global.get $A)))
      (local.set $top (i32.mul (local.get $pos) (i32.add (local.get $size) (i32.const 1))))
      (local.set $bottom (i32.mul (i32.sub (i32.sub (local.get $size) (local.get $pos)) (i32.const 1))
        (i32.add (local.get $size) (i32.const 1))))
      (local.set $left (i32.sub (i32.shr_u (local.get $size) (i32.const 1)) (local.get $pos)))
      (local.set $right (i32.add (i32.shr_u (local.get $size) (i32.const 1)) (local.get $pos)))
      (i32.store8 (i32.add (i32.add (global.get $outputOffset)
        (local.get $top)) (local.get $left)) (local.get $letter))
      (i32.store8 (i32.add (i32.add (global.get $outputOffset) 
        (local.get $top)) (local.get $right)) (local.get $letter))
      (i32.store8 (i32.add (i32.add (global.get $outputOffset)
        (local.get $bottom)) (local.get $left)) (local.get $letter))
      (i32.store8 (i32.add (i32.add (global.get $outputOffset)
        (local.get $bottom)) (local.get $right)) (local.get $letter))
      (local.set $letter (i32.sub (local.get $letter) (i32.const 1)))
    (br_if $lines (i32.ge_u (local.get $letter) (global.get $A))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)