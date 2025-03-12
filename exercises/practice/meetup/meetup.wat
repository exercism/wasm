(module
  ;; Weeks
  (global (export "first") i32 (i32.const 0))
  (global (export "second") i32 (i32.const 1))
  (global (export "third") i32 (i32.const 2))
  (global (export "fourth") i32 (i32.const 3))
  (global (export "last") i32 (i32.const 4))
  (global (export "teenth") i32 (i32.const 5))

  ;; Weekdays
  (global (export "Sunday") i32 (i32.const 0))
  (global (export "Monday") i32 (i32.const 1))
  (global (export "Tuesday") i32 (i32.const 2))
  (global (export "Wednesday") i32 (i32.const 3))
  (global (export "Thursday") i32 (i32.const 4))
  (global (export "Friday") i32 (i32.const 5))
  (global (export "Saturday") i32 (i32.const 6))

  ;;
  ;; Get the year, month and day of the specified date
  ;;
  ;; @param {i32} $year - 4 digit year (e.g 2013)
  ;; @param {i32} $month - month (starting by 1)
  ;; @param {i32} $week - 0 = first, 1 = second, 2 = third, 3 = fourth, 4 = last, 5 = teenth
  ;; @param {i32} $weekday - 0 = Sunday, 1 = Monday, ...
  ;;
  ;; @returns {(i32,i32,i32)} - year, month - 1 (for JS) and day of the specified date
  ;;
  (func (export "meetup") (param $year i32) (param $month i32)
    (param $week i32) (param $weekday i32) (result i32 i32 i32)
    (i32.const 0) (i32.const 0) (i32.const 0)
  )
)