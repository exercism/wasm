(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the price of shopping basket of books
  ;;
  ;; @param {i32} basketOffset - offset of input u32[] array
  ;; @param {i32} basketLength - length of input u32[] array in elements
  ;;
  ;; @return {i32} - price of shopping basket
  ;;
  (func (export "total") (param $basketOffset i32) (param $basketLength i32) (result i32)
    (return (i32.const 0))
  )
)
