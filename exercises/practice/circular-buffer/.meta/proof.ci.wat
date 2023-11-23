(module
  (memory 1 1)
  (global $head (mut i32) (i32.const -1))
  (global $tail (mut i32) (i32.const -1))
  (global $capacity (mut i32) (i32.const 0))
  (global $i32Size i32 (i32.const 4))

  ;;
  ;; Initialize a circular buffer of i32s with a given capacity
  ;;
  ;; @param {i32} newCapacity - capacity of the circular buffer between 0 and 16,384
  ;;                            in order to fit in a single 64KiB WebAssembly page
  ;;
  ;; @returns {i32} 0 on success or -1 on error
  ;; 
  (func (export "init") (param $newCapacity i32) (result i32)
    ;; a WebAssembly page is 4096 bytes, so up to 1024 i32s
    (if (i32.gt_s (local.get $newCapacity) (i32.const 16384)) (then
      (return (i32.const -1))
    ))

    (global.set $head (i32.const -1))
    (global.set $tail (i32.const -1))
    (global.set $capacity (local.get $newCapacity))
    (i32.const 0)
  )

  ;;
  ;; Clear the circular buffer
  ;;
  (func (export "clear")
    (global.set $head (i32.const -1))
    (global.set $tail (i32.const -1))
  )

  ;; 
  ;; Add an element to the circular buffer
  ;;
  ;; @param {i32} elem - element to add to the circular buffer
  ;;
  ;; @returns {i32} 0 on success or -1 if full
  ;;
  (func (export "write") (param $elem i32) (result i32)
    (local $temp i32)
    ;; Table has capacity of zero
    (if (i32.eq (global.get $capacity) (i32.const 0)) (then
      (return (i32.const -1))
    ))

    ;; if head is -1, circular buffer is empty
    (if (i32.eq (global.get $head) (i32.const -1)) (then
      (global.set $head (i32.const 0))
      (global.set $tail (i32.const 0))
      (i32.store (i32.mul (global.get $tail) (global.get $i32Size)) (local.get $elem))
    ) (else 
      (local.set $temp (i32.rem_u (i32.add (global.get $tail) (i32.const 1)) (global.get $capacity)))
      ;; If tail is one less than head, we're full
      (if (i32.eq (local.get $temp) (global.get $head)) (then
        (return (i32.const -1))
      ))

      (global.set $tail (local.get $temp))
      (i32.store (i32.mul (global.get $tail) (global.get $i32Size)) (local.get $elem))
    ))

    (i32.const 0)
  )

  ;; 
  ;; Add an element to the circular buffer, overwriting the oldest element
  ;; if the buffer is full
  ;;
  ;; @param {i32} elem - element to add to the circular buffer
  ;;
  ;; @returns {i32} 0 on success or -1 if full (capacity of zero)
  ;;
  (func (export "forceWrite") (param $elem i32) (result i32)
    (local $temp i32)
    ;; Table has capacity of zero
    (if (i32.eq (global.get $capacity) (i32.const 0)) (then
      (return (i32.const -1))
    ))

    ;; if head is -1, circular buffer is empty
    (if (i32.eq (global.get $head) (i32.const -1)) (then
      (global.set $head (i32.const 0))
      (global.set $tail (i32.const 0))
      (i32.store (i32.mul (global.get $tail) (global.get $i32Size)) (local.get $elem))
    ) (else 
      (local.set $temp (i32.rem_u (i32.add (global.get $tail) (i32.const 1)) (global.get $capacity)))
      ;; If tail is one less than head, we're full. Advance head and overwrite
      (if (i32.eq (local.get $temp) (global.get $head)) (then
        (global.set $head (i32.rem_u (i32.add (global.get $head) (i32.const 1)) (global.get $capacity)))
      ))

      (global.set $tail (local.get $temp))
      (i32.store (i32.mul (global.get $tail) (global.get $i32Size)) (local.get $elem))
    ))

    (i32.const 0)
  )

  ;;
  ;; Read the oldest element from the circular buffer, if not empty
  ;;
  ;; @returns {i32} element on success or -1 if empty
  ;; @returns {i32} status code set to 0 on success or -1 if empty
  ;;
  (func (export "read") (result i32 i32)
    (local $result i32)

    ;; if head is -1, circular buffer is empty
    (if (i32.eq (global.get $head) (i32.const -1)) (then
      (return (i32.const -1) (i32.const -1))
    ))

    ;; if head and tail are equal, we have one element
    (if (i32.eq (global.get $head) (global.get $tail)) (then
      (local.set $result (i32.load (i32.mul (global.get $head) (global.get $i32Size))))
      (global.set $head (i32.const -1))
      (global.set $tail (i32.const -1))
      (return (local.get $result) (i32.const 0) )
    ))

    (local.set $result (i32.load (i32.mul (global.get $head) (global.get $i32Size))))
    (global.set $head (i32.rem_u (i32.add (global.get $head) (i32.const 1)) (global.get $capacity)))
    (return (local.get $result) (i32.const 0))
  )
)
