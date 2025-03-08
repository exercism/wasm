(module
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
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
    (i32.const 0)
  )
)