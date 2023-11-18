;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;; returns 0 on success, -1 on failure
  (func (export "open") (result i32)
    (i32.const 42)
  )

  ;; returns 0 on success, -1 on failure
  (func (export "close") (result i32)
    (i32.const 42)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount negative
  (func (export "deposit") (param $amount i32) (result i32)
    (i32.const 42)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount invalid
  (func (export "withdraw") (param $amount i32) (result i32)
    (i32.const 42)
  )

  ;; returns balance on success, -1 if account closed
  (func (export "balance") (result i32)
    (i32.const 42)
  )
)
