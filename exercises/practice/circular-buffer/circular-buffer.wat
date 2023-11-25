(module
  ;; Linear memory is allocated one page by default.
  ;; A page is 64KiB, and that can hold up to 16384 i32s.
  ;; We will permit memory to grow to a maximum of four pages.
  ;; The maximum capacity of our buffer is 65536 i32s.
  (memory (export "mem") 1 4)
  ;; Add globals here!

  ;;
  ;; Initialize a circular buffer of i32s with a given capacity
  ;;
  ;; @param {i32} newCapacity - capacity of the circular buffer between 0 and 65,536
  ;;                            in order to fit in four 64KiB WebAssembly pages.
  ;;
  ;; @returns {i32} 0 on success or -1 on error
  ;; 
  (func (export "init") (param $newCapacity i32) (result i32)
    (i32.const 42)
  )

  ;;
  ;; Clear the circular buffer
  ;;
  (func (export "clear")
    (nop)
  )

  ;; 
  ;; Add an element to the circular buffer
  ;;
  ;; @param {i32} elem - element to add to the circular buffer
  ;;
  ;; @returns {i32} 0 on success or -1 if full
  ;;
  (func (export "write") (param $elem i32) (result i32)
    (i32.const 42)
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
    (i32.const 42)
  )

  ;;
  ;; Read the oldest element from the circular buffer, if not empty
  ;;
  ;; @returns {i32} element on success or -1 if empty
  ;; @returns {i32} status code set to 0 on success or -1 if empty
  ;;
  (func (export "read") (result i32 i32)
    (return (i32.const 42) (i32.const 42))
  )
)
