(module
  ;; Private globals
  (global $open (mut i32) (i32.const 0))
  (global $balance (mut i32) (i32.const 0))

  ;; returns 0 on success, -1 on failure
  (func (export "open") (result i32)
    (if (global.get $open) (then (return (i32.const -1))))

    (global.set $open (i32.const 1))
    (global.set $balance (i32.const 0))
    (i32.const 0)
  )

  ;; returns 0 on success, -1 on failure
  (func (export "close") (result i32)
    (if (i32.eqz (global.get $open)) (then (return (i32.const -1))))

    (global.set $open (i32.const 0))
    (global.set $balance (i32.const 0))
    (i32.const 0)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount negative
  (func (export "deposit") (param $amount i32) (result i32)
    (if (i32.eqz (global.get $open)) (then (return (i32.const -1))))
    (if (i32.lt_s (local.get $amount) (i32.const 0)) (then (return (i32.const -2))))

    (global.set $balance (i32.add (global.get $balance) (local.get $amount)))
    (i32.const 0)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount invalid
  (func (export "withdraw") (param $amount i32) (result i32)
    (if (i32.eqz (global.get $open)) (then (return (i32.const -1))))
    (if (i32.or
      (i32.lt_s (local.get $amount) (i32.const 0)) 
      (i32.gt_s (local.get $amount) (global.get $balance)) 
    ) (then (return (i32.const -2))))

    (global.set $balance (i32.sub (global.get $balance) (local.get $amount)))
    (i32.const 0)
  )

  ;; returns balance on success, -1 if account closed
  (func (export "balance") (result i32)
    (if (i32.eqz (global.get $open)) (then (return (i32.const -1))))

    (global.get $balance)
  )
)
