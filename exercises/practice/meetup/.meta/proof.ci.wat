(module
  (memory 1)

  ;; Weeks
  (global (export "first") i32 (i32.const 0))
  (global (export "second") i32 (i32.const 1))
  (global (export "third") i32 (i32.const 2))
  (global (export "fourth") i32 (i32.const 3))
  (global (export "teenth") i32 (i32.const 4))
  (global (export "last") i32 (i32.const 5))

  ;; Weekdays
  (global (export "Sunday") i32 (i32.const 0))
  (global (export "Monday") i32 (i32.const 1))
  (global (export "Tuesday") i32 (i32.const 2))
  (global (export "Wednesday") i32 (i32.const 3))
  (global (export "Thursday") i32 (i32.const 4))
  (global (export "Friday") i32 (i32.const 5))
  (global (export "Saturday") i32 (i32.const 6))

  (global $weeks i32 (i32.const 13))
  (global $last i32 (i32.const 18))

  (data (i32.const 1) "\00\03\03\06\01\04\06\02\05\00\03\05\01\08\0f\16\0d\00\19\16\19\18\19\18\19\19\18\19\18\19")
  ;;
  ;; Get the year, month and day of the specified date
  ;;
  ;; @param {i32} $year - 4 digit year (e.g 2013)
  ;; @param {i32} $month - month (starting by 1)
  ;; @param {i32} $week - 0 = first, 1 = second, 2 = third, 3 = fourth, 4 = teenth, 5 = last
  ;; @param {i32} $weekday - 0 = Sunday, 1 = Monday, ...
  ;;
  ;; @returns {(i32,i32,i32)} - year, month and day of the specified date
  ;;
  (func (export "meetup") (param $year i32) (param $month i32)
    (param $week i32) (param $weekday i32) (result i32 i32 i32)
    ;; 1. find out the weekday of the first day of the year:
    ;; (1 + 5((year−1) % 4) + 4((year−1) % 100) + 6((year−1) % 400)) % 7
    (local $prevYear i32)
    (local $leap i32)
    (local $first i32)
    (local $day i32)
    (local.set $prevYear (i32.sub (local.get $year) (i32.const 1)))
    (local.set $first (i32.rem_u (i32.add (i32.const 1) (i32.add  
      (i32.mul (i32.const 5) (i32.rem_u (local.get $prevYear) (i32.const 4))) 
      (i32.add (i32.mul (i32.const 4) (i32.rem_u (local.get $prevYear) (i32.const 100)))
      (i32.mul (i32.const 6) (i32.rem_u (local.get $prevYear) (i32.const 400)))))) (i32.const 7)))
    ;; 2. get the first day of the month using the table (+1 for month > 2 on leap years)
    (local.set $leap
      (i32.or (i32.and (i32.eqz (i32.rem_u (local.get $year) (i32.const 4))) 
      (i32.ne (i32.rem_u (local.get $year) (i32.const 100)) (i32.const 0))
      (i32.eqz (i32.rem_u (local.get $year) (i32.const 400))))))
    (local.set $first (i32.rem_u (i32.add (i32.add (local.get $first)
      (i32.load8_u (local.get $month))) (i32.const 0)) (i32.const 7)))
    (if (i32.and (local.get $leap) (i32.gt_u (local.get $month) (i32.const 2)))
      (then (local.set $first (i32.add (local.get $first) (i32.const 1)))))
    ;; 3. put the day within the week in question
    (local.set $day (i32.load8_u (i32.add (global.get $weeks) (local.get $week))))
    ;; 3.1 handle last week of month
    (if (i32.eqz (local.get $day))
      (then (local.set $day (i32.add (i32.load8_u (i32.add (global.get $last) (local.get $month)))
        (i32.and (local.get $leap) (i32.eq (local.get $month) (i32.const 2)))))))
    ;; 4. align to the required weekday
    ;; = $day + ((7 + $weekday - ((6 + $day + $first) % 7)) % 7) 
    (local.set $day (i32.add (local.get $day)   
      (i32.rem_u (i32.sub (i32.add (local.get $weekday) (i32.const 7)) 
        (i32.rem_u (i32.add (i32.const 6) (i32.add (local.get $day) (local.get $first)))
        (i32.const 7))) (i32.const 7))))
    (local.get $year) (local.get $month) (local.get $day)
  )
)