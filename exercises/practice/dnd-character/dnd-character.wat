(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 1)

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
    (i32.const 0)
  )

  ;;
  ;; Roll an attribute for a DnD Character
  ;;
  ;; @returns {i32} - the sum of the 3 highest of 4 6-sided dices
  ;;
  (func $rollAbility (export "rollAbility") (result i32)
    (i32.const 4)
  )

  ;;
  ;; Generates the attribute values for a DnD Character:
  ;; strength, dexterity, constitution, intelligence, wisdom, charisma and hitpoints
  ;;
  ;; @returns {(i32,i32)} - offset and length of an i32-array of the values
  ;;
  (func (export "createCharacter") (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)