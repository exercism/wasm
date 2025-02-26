(module
  (memory (export "mem") 1)
  
  (global $br i32 (i32.const 10))
  (global $corner i32 (i32.const 43))
  (global $horizontal i32 (i32.const 45))
  (global $vertical i32 (i32.const 124))

  ;;
  ;; Count the rectangles in a grid with lines each ending with line breaks
  ;;
  ;; @param {i32} inputOffset - offset of the grid in linear memory
  ;; @param {i32} inputLength - length of the grid in linear memory
  ;;
  ;; @returns {i32} - number of rectangles in the grid
  ;;
  (func (export "count") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (local $rectangles i32)
    (local $xmax i32)
    (local $ymax i32)
    (local $x1 i32)
    (local $x2 i32)
    (local $xb i32)
    (local $y1 i32)
    (local $y2 i32)
    (local $char i32)
    (local $char2 i32)
    (loop $measureLine
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $xmax))))
      (if (i32.and (i32.lt_u (local.get $xmax) (local.get $inputLength))
        (i32.ne (local.get $char) (global.get $br)))
      (then (local.set $xmax (i32.add (local.get $xmax) (i32.const 1))) (br $measureLine))))
    (if (local.get $xmax) (then (local.set $ymax (i32.div_u (local.get $inputLength) (local.get $xmax)))))
    (loop $y_1
      (local.set $x1 (i32.const 0))
      (loop $x_1
        ;; find first corner
        (if (i32.eq (i32.load8_u (i32.add (local.get $inputOffset) (i32.add 
          (i32.mul (local.get $y1) (i32.add (local.get $xmax) (i32.const 1)))
            (local.get $x1)))) (global.get $corner)) (then
          ;; find second corner
          (local.set $x2 (i32.add (local.get $x1) (i32.const 1)))
          (loop $x_2
            (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) 
              (i32.add (i32.mul (local.get $y1) (i32.add (local.get $xmax) (i32.const 1))) (local.get $x2)))))
            (if (i32.eq (local.get $char) (global.get $corner)) (then
              (local.set $y2 (i32.add (local.get $y1) (i32.const 1)))
              (loop $y_2
                ;; left side is corner or vertical line, otherwise jump to end
                (local.set $char2 (i32.load8_u (i32.add (local.get $inputOffset) 
                  (i32.add (i32.mul (local.get $y2) (i32.add (local.get $xmax) (i32.const 1))) (local.get $x1)))))
                (if (i32.eqz (i32.or (i32.eq (local.get $char2) (global.get $vertical))
                  (i32.eq (local.get $char2) (global.get $corner)))) (then
                    (local.set $y2 (local.get $ymax))))
                ;; right side is corner or vertical line, otherwise jump to end
                (local.set $char2 (i32.load8_u (i32.add (local.get $inputOffset) 
                  (i32.add (i32.mul (local.get $y2) (i32.add (local.get $xmax) (i32.const 1))) (local.get $x2)))))
                (if (i32.eqz (i32.or (i32.eq (local.get $char2) (global.get $vertical))
                  (i32.eq (local.get $char2) (global.get $corner)))) (then
                    (local.set $y2 (local.get $ymax))))
                (local.set $char2 (i32.or (i32.shl (local.get $char2) (i32.const 8))
                  (i32.load8_u (i32.add (local.get $inputOffset) 
                  (i32.add (i32.mul (local.get $y2) (i32.add (local.get $xmax) (i32.const 1))) (local.get $x1))))))
                ;; both sides are corners
                (if (i32.eq (local.get $char2) (i32.or (i32.shl (global.get $corner) (i32.const 8))
                  (global.get $corner))) (then 
                    ;; check bottom line
                    (local.set $xb (i32.add (local.get $x1) (i32.const 1)))
                    (loop $bottomLine
                      (local.set $char2 (i32.load8_u (i32.add (local.get $inputOffset) 
                      (i32.add (i32.mul (local.get $y2) (i32.add (local.get $xmax) (i32.const 1))) (local.get $xb)))))
                      (local.set $char2 (i32.or (i32.eq (local.get $char2) (global.get $horizontal))
                        (i32.eq (local.get $char2) (global.get $corner))))
                      (local.set $xb (i32.add (local.get $xb) (i32.const 1)))
                    (br_if $bottomLine (i32.and (local.get $char2) (i32.lt_u (local.get $xb) (local.get $x2)))))
                    (if (local.get $char2) (then
                      (local.set $rectangles (i32.add (local.get $rectangles) (i32.const 1)))))
                  ))
                (local.set $y2 (i32.add (local.get $y2) (i32.const 1)))
              (br_if $y_2 (i32.lt_u (local.get $y2) (local.get $ymax))))
            ))
            (local.set $x2 (i32.add (local.get $x2) (i32.const 1)))
          ;; loop only if not at max and [x2,y1] is horizontal line or corner
          (br_if $x_2 (i32.and (i32.lt_u (local.get $x2) (local.get $xmax)) 
            (i32.or (i32.eq (local.get $char) (global.get $horizontal))
            (i32.eq (local.get $char) (global.get $corner))))))))
          (local.set $x1 (i32.add (local.get $x1) (i32.const 1)))
      (br_if $x_1 (i32.lt_s (i32.add (local.get $x1) (i32.const 1)) (i32.sub (local.get $xmax) (i32.const 1)))))
      (local.set $y1 (i32.add (local.get $y1) (i32.const 1)))
    (br_if $y_1 (i32.lt_s (i32.add (local.get $y1) (i32.const 1)) (i32.sub (local.get $ymax) (i32.const 1)))))
    (local.get $rectangles)
  )
)