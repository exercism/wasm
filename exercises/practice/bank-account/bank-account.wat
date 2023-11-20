(module
  ;;
  ;; Set the state of the bank account to open.
  ;;
  ;; @return {i32} 0 on success, -1 on failure
  ;;
  (func (export "open") (result i32)
    (i32.const 42)
  )

  ;;
  ;; Set the state of the bank account to closed.
  ;;
  ;; @return {i32} 0 on success, -1 on failure
  ;;
  (func (export "close") (result i32)
    (i32.const 42)
  )

  ;;
  ;; Deposit the given amount into the bank account.
  ;;
  ;; @param {i32} amount - The amount to deposit
  ;;
  ;; @return {i32} 0 on success, -1 if account closed, -2 if amount negative
  ;;
  (func (export "deposit") (param $amount i32) (result i32)
    (i32.const 42)
  )

  ;;
  ;; Withdraw the given amount from the bank account.
  ;;
  ;; @param {i32} amount - The amount to withdraw
  ;;
  ;; @return {i32} 0 on success, -1 if account closed, -2 if amount invalid
  ;;
  (func (export "withdraw") (param $amount i32) (result i32)
    (i32.const 42)
  )

  ;;
  ;; Get the current balance of the bank account.
  ;;
  ;; @return {i32} balance on success, -1 if account closed
  ;;
  (func (export "balance") (result i32)
    (i32.const 42)
  )
)
