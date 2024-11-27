(module
  (memory (export "mem") 1)

  ;;
  ;; Create the next frame of Conway's Game of Life
  ;;
  ;; @param {i32} offset - The offset of the current frame in linear memory
  ;; @param {i32} length - The length of the current frame in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the next frame in linear memory
  ;;
  (func (export "next") (param $offset i32) (param $cols i32) (param $rows i32) (result i32)
    (local $pos i32) (local $nbpos i32) (local $length i32) (local $count i32) (local $edges i32) (local $bottom i32)
    (local.set $length (i32.mul (local.get $cols) (local.get $rows)))
    (local.set $bottom (i32.mul (i32.sub (local.get $rows) (i32.const 1)) (local.get $cols)))
    (loop $cell
      (local.set $edges 
        (i32.or (i32.shl (i32.lt_u (local.get $pos) (local.get $cols)) (i32.const 3)) ;; top
        (i32.or (i32.shl (i32.ge_u (local.get $pos) (local.get $bottom)) (i32.const 2)) ;; bottom
        (i32.or (i32.shl (i32.eqz (i32.rem_u (local.get $pos) (local.get $cols))) (i32.const 1)) ;; left
                (i32.eq (i32.rem_u (i32.add (local.get $pos) (i32.const 1)) (local.get $cols)) (i32.const 0)))))) ;; right
      (local.set $count
        (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add 
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 10))) ;; -1, -1
            (i32.load8_u (i32.sub (i32.sub (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)) (i32.const 1))))
          (i32.and (i32.eqz (i32.shr_u (local.get $edges) (i32.const 3))) ;; 0, -1
            (i32.load8_u (i32.sub (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 9))) ;; 1, -1
            (i32.load8_u (i32.add (i32.sub (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)) (i32.const 1)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 2))) ;; -1, 0
            (i32.load8_u (i32.sub (i32.add (local.get $offset) (local.get $pos)) (i32.const 1)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 1))) ;; 1, 0
            (i32.load8_u (i32.add (i32.add (local.get $offset) (local.get $pos)) (i32.const 1)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 6))) ;; -1, 1
            (i32.load8_u (i32.sub (i32.add (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)) (i32.const 1)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 4))) ;; 0, 1
            (i32.load8_u (i32.add (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)))))
          (i32.and (i32.eqz (i32.and (local.get $edges) (i32.const 5))) ;; 1, 1
            (i32.load8_u (i32.add (i32.add (i32.add (local.get $offset) (local.get $pos)) (local.get $cols)) (i32.const 1))))))
      (i32.store8 (i32.add (i32.const 128) (local.get $pos))
        (i32.eq (i32.or (i32.load8_u (i32.add (local.get $offset) (local.get $pos)))
          (local.get $count)) (i32.const 3)))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $cell (i32.lt_u (local.get $pos) (local.get $length))))
  )
)
