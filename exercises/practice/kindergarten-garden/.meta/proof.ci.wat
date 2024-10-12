(module
  (memory (export "mem") 1)

  (data $names (i32.const 195) "a  b  clover,  f  grass,   j  k  l  m  n  o  p  q  radishes,   violets, y  z")

  (global $cloverLength i32 (i32.const 8))
  (global $grassLength i32 (i32.const 7))
  (global $radishesLength i32 (i32.const 10))
  (global $violetsLength i32 (i32.const 9))
  (global $commaLength i32 (i32.const 2))

  (global $A i32 (i32.const 65))
  (global $C i32 (i32.const 67))
  (global $G i32 (i32.const 71))
  (global $R i32 (i32.const 82))
  (global $V i32 (i32.const 86))

  (func $appendPlant (param $destOffset i32) (param $plant i32) (result i32)
    (local $plantLength i32)
    (if (i32.eq (local.get $plant) (global.get $C)) (then
      (local.set $plantLength (global.get $cloverLength))
    ))
    (if (i32.eq (local.get $plant) (global.get $G)) (then
      (local.set $plantLength (global.get $grassLength))
    ))
    (if (i32.eq (local.get $plant) (global.get $R)) (then
      (local.set $plantLength (global.get $radishesLength))
    ))
    (if (i32.eq (local.get $plant) (global.get $V)) (then
      (local.set $plantLength (global.get $violetsLength))
    ))

    (memory.copy
      (local.get $destOffset)
      (i32.mul (i32.const 3) (local.get $plant))
      (local.get $plantLength)
    )

    (return
      (i32.add
        (local.get $destOffset)
        (local.get $plantLength)
      )
    )
  )

  ;;
  ;; Determine which plants a child in the kindergarten class is responsible for.
  ;;
  ;; @param {i32} diagramOffset - The offset of the diagram string in linear memory.
  ;; @param {i32} diagramLength - The length of the diagram string in linear memory.
  ;; @param {i32} studentOffset - The offset of the student string in linear memory.
  ;; @param {i32} studentLength - The length of the student string in linear memory.
  ;;
  ;; @returns {(i32,i32)} - Offset and length of plants string
  ;;                        in linear memory.
  ;;
  (func (export "plants")
    (param $diagramOffset i32) (param $diagramLength i32) (param $studentOffset i32) (param $studentLength i32) (result i32 i32)
    (local $dest i32)
    (local $diagramHalfLength i32)
    (local $first i32)
    (local $second i32)
    (local $third i32)
    (local $fourth i32)

    (local.set $diagramHalfLength
      (i32.shr_u
        (i32.add
          (local.get $diagramLength)
          (i32.const 1)
        )
        (i32.const 1)
      )
    )

    (local.set $first
      (i32.add
        (local.get $diagramOffset)
        (i32.shl
          (i32.sub
            (i32.load8_u (local.get $studentOffset))
            (global.get $A)
          )
          (i32.const 1)
        )
      )
    )

    (local.set $second
      (i32.add
        (local.get $first)
        (i32.const 1)
      )
    )

    (local.set $third
      (i32.add
        (local.get $diagramHalfLength)
        (local.get $first)
      )
    )

    (local.set $fourth
      (i32.add
        (local.get $third)
        (i32.const 1)
      )
    )

    ;; We overwrite the student string
    (local.set $dest
      (local.get $studentOffset)
    )

    (local.set $dest
      (call $appendPlant
        (local.get $dest)
        (i32.load8_u (local.get $first))
      )
    )

    (local.set $dest
      (call $appendPlant
        (local.get $dest)
        (i32.load8_u (local.get $second))
      )
    )

   (local.set $dest
      (call $appendPlant
        (local.get $dest)
        (i32.load8_u (local.get $third))
      )
    )

    (local.set $dest
      (call $appendPlant
        (local.get $dest)
        (i32.load8_u (local.get $fourth))
      )
   )

    (local.set $dest
      (i32.sub
        (local.get $dest)
        (global.get $commaLength)
      )
    )

    (return
      (local.get $studentOffset)

      (i32.sub
        (local.get $dest)
        (local.get $studentOffset)
      )
    )
  )
)
