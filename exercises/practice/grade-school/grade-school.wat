(module
  (memory (export "mem") 1)

  ;;
  ;; Add a student to the roster
  ;; Already added students with the same name overwrite previous ones
  ;;
  ;; @param {i32} $nameOffset - offset of the student's name in linear memory
  ;; @param {i32} $nameLength - length of the student's name in linear memory
  ;; @param {i32} $grade - grade of the student
  ;;
  (func (export "add") (param $nameOffset i32) (param $nameLength i32) (param $grade i32)

  )

  ;;
  ;; Generate the roster for all grades
  ;;
  ;; @returns {(i32,i32)} - offset and length of the roster in linear memory
  ;;
  (func (export "roster") (result i32 i32)
    (i32.const 0) (i32.const 0)
  )

  ;;
  ;; Generate a list of students for a grade
  ;;
  ;; @param {i32} $grade
  ;;
  ;; @returns {(i32,i32)} - offset and length of the list of students for the grade in linear memory
  ;;
  (func (export "grade") (param $grade i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)
