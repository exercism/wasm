(module
  (import "console" "log_i32_s" (func $log_i32_s (param i32)))
  ;;
  ;; Score a yacht game of ones
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "ones") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 1))
      (i32.eq (local.get $diceB) (i32.const 1)))
      (i32.eq (local.get $diceC) (i32.const 1)))
      (i32.eq (local.get $diceD) (i32.const 1)))
      (i32.eq (local.get $diceE) (i32.const 1)))
  )

  ;;
  ;; Score a yacht game of twos
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "twos") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.shl (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 2))
      (i32.eq (local.get $diceB) (i32.const 2)))
      (i32.eq (local.get $diceC) (i32.const 2)))
      (i32.eq (local.get $diceD) (i32.const 2)))
      (i32.eq (local.get $diceE) (i32.const 2))) (i32.const 1))
  )

  ;;
  ;; Score a yacht game of threes
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "threes") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.mul (i32.const 3) (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 3))
      (i32.eq (local.get $diceB) (i32.const 3)))
      (i32.eq (local.get $diceC) (i32.const 3)))
      (i32.eq (local.get $diceD) (i32.const 3)))
      (i32.eq (local.get $diceE) (i32.const 3))))
  )

  ;;
  ;; Score a yacht game of fours
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "fours") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.shl (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 4))
      (i32.eq (local.get $diceB) (i32.const 4)))
      (i32.eq (local.get $diceC) (i32.const 4)))
      (i32.eq (local.get $diceD) (i32.const 4)))
      (i32.eq (local.get $diceE) (i32.const 4))) (i32.const 2))
  )

  ;;
  ;; Score a yacht game of fives
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "fives") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.mul (i32.const 5) (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 5))
      (i32.eq (local.get $diceB) (i32.const 5)))
      (i32.eq (local.get $diceC) (i32.const 5)))
      (i32.eq (local.get $diceD) (i32.const 5)))
      (i32.eq (local.get $diceE) (i32.const 5))))
  )

  ;;
  ;; Score a yacht game of sixes
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "sixes") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.mul (i32.const 6) (i32.add (i32.add (i32.add (i32.add
      (i32.eq (local.get $diceA) (i32.const 6))
      (i32.eq (local.get $diceB) (i32.const 6)))
      (i32.eq (local.get $diceC) (i32.const 6)))
      (i32.eq (local.get $diceD) (i32.const 6)))
      (i32.eq (local.get $diceE) (i32.const 6))))
  )

  ;;
  ;; Score a yacht game of full house
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "full house") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (local $count i32)
    (local $triple i32)
    (local $double i32)
    (local $face i32)
    (loop $faces
      (local.set $face (i32.add (local.get $face) (i32.const 1)))
      (local.set $count (i32.add (i32.add (i32.add (i32.add
        (i32.eq (local.get $diceA) (local.get $face))
        (i32.eq (local.get $diceB) (local.get $face)))
        (i32.eq (local.get $diceC) (local.get $face)))
        (i32.eq (local.get $diceD) (local.get $face)))
        (i32.eq (local.get $diceE) (local.get $face))))
      (if (i32.eq (local.get $count) (i32.const 2)) (then
        (local.set $double (i32.shl (local.get $face) (i32.const 1)))))
      (if (i32.eq (local.get $count) (i32.const 3)) (then
        (local.set $triple (i32.mul (local.get $face) (i32.const 3)))))
      (if (local.get $double) (then (if (local.get $triple) (then
        (return (i32.add (local.get $double) (local.get $triple)))))))
    (br_if $faces (i32.le_u (local.get $face) (i32.const 6))))
    (i32.const 0)
  )

  ;;
  ;; Score a yacht game of four of a kind
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "four of a kind") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (local $face i32)
    (loop $faces
      (local.set $face (i32.add (local.get $face) (i32.const 1)))
      (if (i32.ge_u (i32.add (i32.add (i32.add (i32.add
        (i32.eq (local.get $diceA) (local.get $face))
        (i32.eq (local.get $diceB) (local.get $face)))
        (i32.eq (local.get $diceC) (local.get $face)))
        (i32.eq (local.get $diceD) (local.get $face)))
        (i32.eq (local.get $diceE) (local.get $face))) (i32.const 4))
      (then (return (i32.mul (local.get $face) (i32.const 4)))))
    (br_if $faces (i32.le_u (local.get $face) (i32.const 6))))
    (i32.const 0)
  )

  ;;
  ;; Score a yacht game of little straight
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "little straight") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 30) (i32.const 0)
      (i32.eq (i32.or (i32.or (i32.or (i32.or
        (i32.shl (i32.const 1) (local.get $diceA))
        (i32.shl (i32.const 1) (local.get $diceB)))
        (i32.shl (i32.const 1) (local.get $diceC)))
        (i32.shl (i32.const 1) (local.get $diceD)))
        (i32.shl (i32.const 1) (local.get $diceE))) 
        (i32.const 62)))
  )

  ;;
  ;; Score a yacht game of big straight
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "big straight") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 30) (i32.const 0)
      (i32.eq (i32.or (i32.or (i32.or (i32.or
        (i32.shl (i32.const 1) (local.get $diceA))
        (i32.shl (i32.const 1) (local.get $diceB)))
        (i32.shl (i32.const 1) (local.get $diceC)))
        (i32.shl (i32.const 1) (local.get $diceD)))
        (i32.shl (i32.const 1) (local.get $diceE))) 
        (i32.const 124)))
  )

  ;;
  ;; Score a yacht game of choice
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "choice") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.add (i32.add (i32.add (i32.add (local.get $diceA)
      (local.get $diceB)) (local.get $diceC))
      (local.get $diceD)) (local.get $diceE))
  )

  ;;
  ;; Score a yacht game of yacht
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "yacht") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 50) (i32.const 0) 
      (i32.and (i32.and (i32.and
        (i32.eq (local.get $diceA) (local.get $diceB))
        (i32.eq (local.get $diceB) (local.get $diceC))
        (i32.eq (local.get $diceC) (local.get $diceD))
        (i32.eq (local.get $diceD) (local.get $diceE))))))
  )
)