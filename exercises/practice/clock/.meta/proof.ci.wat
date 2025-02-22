(module
  (memory (export "mem") 1)
  (global $minutesPerHour i32 (i32.const 60))
  (global $minutesPerDay i32 (i32.const 1440)) ;; 24 * 60
  (global $zero i32 (i32.const 48))
  (global $colon i32 (i32.const 58))

  ;;
  ;; normalizes hours and minutes on a clock, i.e. 25:60 -> 02:00
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;;
  ;; @returns {(i32,i32)} - the normalized hours and minutes shown on the clock
  (func $normalize (param $hour i32) (param $minute i32) (result i32 i32)
    (local $minutes i32)
    (local.set $minutes (i32.add (local.get $minute)
    (i32.mul (local.get $hour) (global.get $minutesPerHour))))
    (loop $negative
      (local.set $minutes (i32.rem_s (i32.add (local.get $minutes)
        (global.get $minutesPerDay)) (global.get $minutesPerDay)))
    (br_if $negative (i32.lt_s (local.get $minutes) (i32.const 0))))
    (i32.div_u (local.get $minutes) (global.get $minutesPerHour))
    (i32.rem_u (local.get $minutes) (global.get $minutesPerHour))
  )

  ;;
  ;; add minutes to a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $increase - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func (export "plus") (param $hour i32) (param $minute i32) (param $increase i32) (result i32 i32)
    (call $normalize (local.get $hour) (i32.add (local.get $minute) (local.get $increase)))
  )

  ;;
  ;; remove minutes from a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $decrease - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func (export "minus") (param $hour i32) (param $minute i32) (param $decrease i32) (result i32 i32)
    (call $normalize (local.get $hour) (i32.sub (local.get $minute) (local.get $decrease)))
  )

  ;;
  ;; formats the clock as "HH:MM" string
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "toString") (param $hour i32) (param $minute i32) (result i32 i32)
    (call $normalize (local.get $hour) (local.get $minute))
      (local.set $minute) (local.set $hour)
    (i32.store8 (i32.const 0) (i32.add (i32.div_u (local.get $hour) (i32.const 10)) (global.get $zero)))
    (i32.store8 (i32.const 1) (i32.add (i32.rem_u (local.get $hour) (i32.const 10)) (global.get $zero)))
    (i32.store8 (i32.const 2) (global.get $colon))
    (i32.store8 (i32.const 3) (i32.add (i32.div_u (local.get $minute) (i32.const 10)) (global.get $zero)))
    (i32.store8 (i32.const 4) (i32.add (i32.rem_u (local.get $minute) (i32.const 10)) (global.get $zero)))
    (i32.const 0) (i32.const 5)
  )

  ;;
  ;; checks if two clocks show the same time
  ;;
  ;; @param {i32} $hourA - the hours on the first clock
  ;; @param {i32} $minuteA - the minutes on the first clock
  ;; @param {i32} $hourB - the hours on the second clock
  ;; @param {i32} $minuteB - the minutes on the second clock
  ;;
  ;; @returns {i32} - 1 if they are equal, 0 if not
  ;;
  (func (export "equals") (param $hourA i32) (param $minuteA i32)
    (param $hourB i32) (param $minuteB i32) (result i32)
    (call $normalize (local.get $hourA) (local.get $minuteA))
      (local.set $minuteA) (local.set $hourA)
    (call $normalize (local.get $hourB) (local.get $minuteB))
      (local.set $minuteB) (local.set $hourB)
    (i32.and (i32.eq (local.get $hourA) (local.get $hourB))
      (i32.eq (local.get $minuteA) (local.get $minuteB)))
  )
)