(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 0))
  (global $outputLength i32 (i32.const 28))
  (global $constitutionBelowThree i32 (i32.const -99999))
  (global $constitutionAboveEighteen i32 (i32.const 99999))

  ;;
  ;; Calculates the ability modifier for the hitpoints of a DnD Character
  ;;
  ;; @param {i32} $constitution
  ;;
  ;; @returns {i32} - modifier for the hitpoints, -99999 if input too small, 99999 if too large
  ;;
  (func $abilityModifier (export "abilityModifier") (param $constitution i32) (result i32)
    (if (i32.lt_s (local.get $constitution) (i32.const 3))
      (then (return (global.get $constitutionBelowThree))))
    (if (i32.gt_s (local.get $constitution) (i32.const 18))
      (then (return (global.get $constitutionAboveEighteen))))
    (i32.shr_s (i32.sub (local.get $constitution) (i32.const 10)) (i32.const 1))
  )

  ;;
  ;; Roll an attribute for a DnD Character
  ;;
  ;; @returns {i32} - the sum of the 3 highest of 4 6-sided dices
  ;;
  (func $rollAbility (export "rollAbility") (result i32)
    (local $dice i32)
    (local $roll i32)
    (local $sum i32)
    (local $min i32)
    (local.set $min (i32.const 7))
    (loop $dices
      (local.set $roll (i32.add (i32.trunc_f64_u (f64.mul (call $random) (f64.const 6.0))) (i32.const 1)))
      (local.set $sum (i32.add (local.get $sum) (local.get $roll)))
      (if (i32.lt_u (local.get $roll) (local.get $min)) (then (local.set $min (local.get $roll))))
      (local.set $dice (i32.add (local.get $dice) (i32.const 1)))
    (br_if $dices (i32.lt_u (local.get $dice) (i32.const 4))))
    (i32.sub (local.get $sum) (local.get $min))
  )

  ;;
  ;; Generates the attribute values for a DnD Character:
  ;; strength, dexterity, constitution, intelligence, wisdom, charisma and hitpoints
  ;;
  ;; @returns {(i32,i32)} - offset and length of an i32-array of the values
  ;;
  (func (export "createCharacter") (result i32 i32)
    (local $count i32)
    (loop $attributes
      (i32.store (i32.shl (local.get $count) (i32.const 2)) (call $rollAbility))
      (local.set $count (i32.add (local.get $count) (i32.const 1)))
    (br_if $attributes (i32.lt_u (local.get $count) (i32.const 6))))
    (i32.store (i32.const 24) (i32.add (i32.const 10) (call $abilityModifier (i32.load (i32.const 8)))))
    (global.get $outputOffset) (global.get $outputLength)
  )
)