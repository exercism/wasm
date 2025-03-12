(module
  (memory (export "mem") 1)

  ;;
  ;; Find the anagrams to the first word in the string of subsequent words
  ;;
  ;; @param {i32} $inputOffset - offset of the word list in linear memory
  ;; @param {i32} $inputLength - length of the word list in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output word list
  ;;
  (func (export "findAnagrams") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (i32.const 0) (i32.const 0)
  )
)