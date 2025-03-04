(module
  (memory (export "mem") 1)
  
  (global $unequal i32 (i32.const 0))
  (global $sublist i32 (i32.const 1))
  (global $equal i32 (i32.const 2))
  (global $superlist i32 (i32.const 3))

  ;;
  ;; Compares two parts of memory.
  ;;
  ;; @param {i32} $firstOffset - offset of the first part in linear memory
  ;; @param {i32} $secondOffset - offset of the second part in linear memory
  ;; @param {i32} $length - length of the parts in linear memory
  ;;
  ;; @returns {i32} - 1 if matches, 0 if not
  ;;
  (func $memcmp (param $firstOffset i32) (param $secondOffset i32) (param $length i32) (result i32)
    (local $idx i32)
    (if (i32.eqz (local.get $length)) (then (return (i32.const 1))))
    (loop $items
      (if (i32.ne (i32.load8_u (i32.add (local.get $firstOffset) (local.get $idx)))
        (i32.load8_u (i32.add (local.get $secondOffset) (local.get $idx))))
        (then (return (i32.const 0))))
      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
    (br_if $items (i32.lt_u (local.get $idx) (local.get $length))))
    (i32.const 1)
  )

  ;;
  ;; Checks if a first (larger) list contains a second (smaller) list
  ;;
  ;; @param {i32} $firstOffset - offset of the first list in linear memory
  ;; @param {i32} $firstLength - length of the first list in linear memory
  ;; @param {i32} $secondOffset - offset of the second list in linear memory
  ;; @param {i32} $secondLength - length of the second list in linear memory
  ;;
  ;; @returns {i32} - 1 if contains
  ;;
  (func $memcontains (param $firstOffset i32) (param $firstLength i32)
    (param $secondOffset i32) (param $secondLength i32) (result i32)
    (local $idx i32)
    (loop $parts
      (if (call $memcmp (i32.add (local.get $firstOffset) (local.get $idx))
        (local.get $secondOffset) (local.get $secondLength)) (then (return (i32.const 1))))
      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
    (br_if $parts (i32.le_s (local.get $idx)
      (i32.sub (local.get $firstLength) (local.get $secondLength)))))
    (i32.const 0)
  )

  ;;
  ;; Compare two lists.
  ;;
  ;; @param {i32} $firstOffset - offset of the first list in linear memory
  ;; @param {i32} $firstLength - length of the first list in linear memory
  ;; @param {i32} $secondOffset - offset of the second list in linear memory
  ;; @param {i32} $secondLength - length of the second list in linear memory
  ;;
  ;; @returns {i32} - $unequal, $sublist, $equal or $superlist
  ;;
  (func (export "compare") (param $firstOffset i32) (param $firstLength i32)
    (param $secondOffset i32) (param $secondLength i32) (result i32)
    (if (i32.eq (local.get $firstLength) (local.get $secondLength))
      (then (if (call $memcmp (local.get $firstOffset) (local.get $secondOffset) (local.get $firstLength))
        (then (return (global.get $equal))))))
    (if (i32.gt_u (local.get $firstLength) (local.get $secondLength))
      (then (if (call $memcontains (local.get $firstOffset) (local.get $firstLength)
        (local.get $secondOffset) (local.get $secondLength)) (then (return (global.get $superlist))))))
    (if (i32.lt_u (local.get $firstLength) (local.get $secondLength))
      (then (if (call $memcontains (local.get $secondOffset) (local.get $secondLength)
        (local.get $firstOffset) (local.get $firstLength)) (then (return (global.get $sublist))))))
    (global.get $unequal)
  )
)