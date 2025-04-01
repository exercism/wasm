(module
  (memory (export "mem") 1)
  
  ;; valid states
  (global $ongoing i32 (i32.const 0))
  (global $draw i32 (i32.const 1))
  (global $win i32 (i32.const 2))
  ;; invalid states
  (global $xtwice i32 (i32.const -1))
  (global $ostarted i32 (i32.const -2))
  (global $movedafterwon i32 (i32.const -3))

  ;; ASCII characters
  (global $X i32 (i32.const 88))
  (global $O i32 (i32.const 79))
  
  ;; winning positions
  (global $length i32 (i32.const 18))
  (global $doublewins i32 (i32.const 8))
  (data (i32.const 0) "\00\07\70\00\07\00\44\04\22\02\11\01\21\04\24\01\44\07\11\07\17\01\47\04\22\07\74\04\27\02\71\01\72\02\25\05")

  ;;
  ;; Get the state of a Tic-Tac-Toe field
  ;;
  ;; @param {i32} $inputOffset
  ;; @param {i32} $inputLength
  ;;
  ;; @returns {i32} - state (see globals for valid/invalid states)
  ;;
  (func (export "gamestate") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (local $x i32)
    (local $o i32)
    (local $char i32)
    (local $pos i32)
    (local $movediff i32)
    (local $wins i32)
    (loop $readboard
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $pos))))
      (if (i32.eq (local.get $char) (global.get $X)) (then
        (local.set $x (i32.or (local.get $x) (i32.shl (i32.const 1) (local.get $pos))))))
      (if (i32.eq (local.get $char) (global.get $O)) (then
        (local.set $o (i32.or (local.get $o) (i32.shl (i32.const 1) (local.get $pos))))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $readboard (i32.lt_u (local.get $pos) (local.get $inputLength))))
    (local.set $movediff (i32.sub (i32.popcnt (local.get $x)) (i32.popcnt (local.get $o))))
    (if (i32.gt_s (local.get $movediff) (i32.const 1)) (then (return (global.get $xtwice))))
    (if (i32.lt_s (local.get $movediff) (i32.const 0)) (then (return (global.get $ostarted))))
    (local.set $pos (i32.const 0))
    (loop $winning
      (local.set $char (i32.load16_u (i32.shl (local.get $pos) (i32.const 1))))
      (if (i32.or (i32.eq (i32.and (local.get $x) (local.get $char)) (local.get $char))
        (i32.eq (i32.and (local.get $o) (local.get $char)) (local.get $char))) (then
          (local.set $wins (i32.add (local.get $wins)
            (select (i32.const 1) (i32.const -1) (i32.lt_u (local.get $pos) (global.get $doublewins)))))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $winning (i32.lt_u (local.get $pos) (global.get $length))))
    (if (i32.gt_u (local.get $wins) (i32.const 1)) (then (return (global.get $movedafterwon))))
    (if (i32.eq (local.get $wins) (i32.const 1)) (then (return (global.get $win))))
    (if (i32.eq (i32.add (i32.popcnt (local.get $x)) (i32.popcnt (local.get $o))) (i32.const 9)) 
      (then (return (global.get $draw))))
    (global.get $ongoing)
  )
)