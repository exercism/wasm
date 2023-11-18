;;
;; Note to CLI Users: Read 'exercises/shared/.docs/debug.md' for instructions
;; on how to log various types of data to the console.
;;

(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (i64.const 42)
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (i64.const 42)
  )
)
