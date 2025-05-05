(module
  (memory (export "mem") 10)

  (data (i32.const 512) "\00\00\00\00")

  (global $studentsOffset i32 (i32.const 512))
  (global $bufferOffset i32 (i32.const 1024))
  (global $bufferLength (mut i32) (i32.const 0))
  (global $outputOffset i32 (i32.const 2048))
  (global $lineBreak i32 (i32.const 10))

  ;;
  ;; Compare two strings
  ;;
  ;; @param {i32} $offsetA - offset of the first string in linear memory
  ;; @param {i32} $lengthA - length of the first string in linear memory
  ;; @param {i32} $offsetB - offset of the second string in linear memory
  ;; @param {i32} $lengthB - length of the second string in linear memory
  ;;
  ;; @returns {i32} - difference of the first deviation or zero if there is none
  ;;
  (func $strcmp (export "strcmp") (param $offsetA i32) (param $lengthA i32) (param $offsetB i32) (param $lengthB i32) (result i32)
    (local $pos i32)
    (local $diff i32)
    (local.set $pos (i32.const -1))
    (loop $chars
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
      (if (i32.or (i32.ge_u (local.get $pos) (local.get $lengthA))
        (i32.ge_u (local.get $pos) (local.get $lengthB))) (then
          (return (select (local.get $diff) 
            (i32.sub (local.get $lengthA) (local.get $lengthB)) (local.get $diff)))))
      (local.set $diff (i32.sub (i32.load8_u (i32.add (local.get $offsetB) (local.get $pos)))
        (i32.load8_u (i32.add (local.get $offsetA) (local.get $pos)))))
    (br_if $chars (i32.eqz (local.get $diff))))
    (local.get $diff)
  )

  (func $sortStudents
    (local $posA i32)
    (local $posB i32)
    (local $offsetA i32)
    (local $offsetB i32)
    (local $lengthA i32)
    (local $lengthB i32)
    (local $diff i32)
    (local $buffer i32)
    (loop $studentA
      (local.set $posB (i32.add (local.get $posA) (i32.const 1)))
      (local.set $offsetA (i32.load16_u (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $posA) (i32.const 2)))))
      (local.set $lengthA (i32.load8_u (i32.add (global.get $studentsOffset)
        (i32.add (i32.shl (local.get $posA) (i32.const 2)) (i32.const 2)))))
      (loop $studentB
        (local.set $offsetB (i32.load16_u (i32.add (global.get $studentsOffset)
          (i32.shl (local.get $posB) (i32.const 2)))))
        (if (local.get $offsetB) (then
          ;; sort by grade
          (local.set $diff (i32.sub
            (i32.load8_u (i32.add (global.get $studentsOffset)
              (i32.add (i32.shl (local.get $posB) (i32.const 2)) (i32.const 3))))
            (i32.load8_u (i32.add (global.get $studentsOffset)
              (i32.add (i32.shl (local.get $posA) (i32.const 2)) (i32.const 3))))))
          ;; sort alphabetically
          (if (i32.eqz (local.get $diff)) (then
            (local.set $lengthB (i32.load8_u (i32.add (global.get $studentsOffset)
              (i32.add (i32.shl (local.get $posB) (i32.const 2)) (i32.const 2)))))
            (local.set $diff (call $strcmp (local.get $offsetA) (local.get $lengthA)
              (local.get $offsetB) (local.get $lengthB)))))
          (if (i32.lt_s (local.get $diff) (i32.const 0)) (then
            (local.set $buffer (i32.load (i32.add (global.get $studentsOffset)
              (i32.shl (local.get $posA) (i32.const 2)))))
            (i32.store (i32.add (global.get $studentsOffset)
              (i32.shl (local.get $posA) (i32.const 2)))
              (i32.load (i32.add (global.get $studentsOffset)
              (i32.shl (local.get $posB) (i32.const 2)))))
            (i32.store (i32.add (global.get $studentsOffset)
              (i32.shl (local.get $posB) (i32.const 2))) (local.get $buffer))))))
        (local.set $posB (i32.add (local.get $posB) (i32.const 1)))
      (br_if $studentB (local.get $offsetB)))
      (local.set $posA (i32.add (local.get $posA) (i32.const 1)))
    (br_if $studentA (local.get $offsetA)))
  )

  ;;
  ;; Add a student to the roster
  ;; Already added students with the same name overwrite previous ones
  ;;
  ;; @param {i32} $nameOffset - offset of the student's name in linear memory
  ;; @param {i32} $nameLength - length of the student's name in linear memory
  ;; @param {i32} $grade - grade of the student
  ;;
  (func (export "add") (param $nameOffset i32) (param $nameLength i32) (param $grade i32)
    (local $pos i32)
    (local $offset i32)
    (local $length i32)
    (local.set $pos (i32.const -1))
    (loop $students
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
      (local.set $offset (i32.load16_u (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2)))))
      (local.set $length (i32.load8_u (i32.add (global.get $studentsOffset)
        (i32.add (i32.shl (local.get $pos) (i32.const 2)) (i32.const 2)))))
      ;; none found
      (if (i32.eqz (local.get $offset)) (then
        (local.set $offset (i32.add (global.get $bufferOffset) (global.get $bufferLength)))
        (local.set $length (local.get $nameLength))
        (memory.copy (local.get $offset) (local.get $nameOffset) (local.get $length))
        (global.set $bufferLength (i32.add (global.get $bufferLength) (local.get $length)))
        (i32.store16 (i32.add (global.get $studentsOffset) (i32.shl (local.get $pos) (i32.const 2)))
          (local.get $offset))
        (i32.store8 (i32.add (i32.add (global.get $studentsOffset)
          (i32.shl (local.get $pos) (i32.const 2))) (i32.const 2)) (local.get $length))
        (i32.store (i32.add (global.get $studentsOffset)
          (i32.shl (i32.add (local.get $pos) (i32.const 1)) (i32.const 2))) (i32.const 0))
      ))
      (if (i32.gt_u (local.get $pos) (i32.const 10)) (then (return)))
    ;; loop if student not found or added
    (br_if $students (call $strcmp (local.get $nameOffset) (local.get $nameLength)
      (local.get $offset) (local.get $length))))
    (i32.store8 (i32.add (i32.add (global.get $studentsOffset)
      (i32.shl (local.get $pos) (i32.const 2))) (i32.const 3)) (local.get $grade))
    (call $sortStudents)
  )

  ;;
  ;; Generate the roster for all grades
  ;;
  ;; @returns {(i32,i32)} - offset and length of the roster in linear memory
  ;;
  (func (export "roster") (result i32 i32)
    (local $pos i32)
    (local $offset i32)
    (local $length i32)
    (local $outputLength i32)
    (loop $students
      (local.set $offset (i32.load16_u (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2)))))
      (local.set $length (i32.load8_u (i32.add (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2))) (i32.const 2))))
      (if (local.get $offset) (then
        (memory.copy (i32.add (global.get $outputOffset) (local.get $outputLength))
          (local.get $offset) (local.get $length))
        (local.set $outputLength (i32.add (local.get $outputLength) (local.get $length)))
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $lineBreak))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $students (local.get $offset)))
    (global.get $outputOffset) (local.get $outputLength)
  )

  ;;
  ;; Generate a list of students for a grade
  ;;
  ;; @param {i32} $grade
  ;;
  ;; @returns {(i32,i32)} - offset and length of the list of students for the grade in linear memory
  ;;
  (func (export "grade") (param $number i32) (result i32 i32)
    (local $pos i32)
    (local $offset i32)
    (local $length i32)
    (local $grade i32)
    (local $outputLength i32)
    (loop $students
      (local.set $offset (i32.load16_u (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2)))))
      (local.set $length (i32.load8_u (i32.add (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2))) (i32.const 2))))
      (local.set $grade (i32.load8_u (i32.add (i32.add (global.get $studentsOffset)
        (i32.shl (local.get $pos) (i32.const 2))) (i32.const 3))))
      (if (i32.eq (local.get $grade) (local.get $number)) (then
        (memory.copy (i32.add (global.get $outputOffset) (local.get $outputLength))
          (local.get $offset) (local.get $length))
        (local.set $outputLength (i32.add (local.get $outputLength) (local.get $length)))
        (i32.store8 (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $lineBreak))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
      ))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $students (local.get $offset)))
    (global.get $outputOffset) (local.get $outputLength)
  )
)

