(module
  (memory (export "mem") 1)

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
    (local.get $hour) (local.get $minute)
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
    (local.get $hour) (local.get $minute)
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
    (i32.const 0) (i32.const 0)
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
    (i32.const 1)
  )
)