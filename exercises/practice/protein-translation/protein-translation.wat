(module
  (memory (export "mem") 1)

  ;;
  ;; Output the space-separated list of proteins specified by the space-separated list of codons
  ;;
  ;; @param {i32} $inputOffset - offset of the codon list in linear memory
  ;; @param {i32} $inputLength - length of the codon list in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the protein list in linear memory
  ;;
  (func (export "translate") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local.get $inputOffset) (local.get $inputLength)
  )
)