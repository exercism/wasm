(module
  (memory (export "mem") 1)
  (data (i32.const 0) "\0e\0b\19\0e\27\08\2f\07\36\09\3f\09\48\0bMethionine\nPhenylalanine\nLeucine\nSerine\nTyrosine\nCysteine\nTryptophan\n")
  (data (i32.const 128) "AUG\00UUU\01UUC\01UUA\02UUG\02UCU\03UCC\03UCA\03UCG\03UAU\04UAC\04UGU\05UGC\05UGG\06UAA\ffUAG\ffUGA\ff")

  (global $keysOffset i32 (i32.const 128))
  (global $keysLength i32 (i32.const 17))
  (global $triByte i32 (i32.const 16777215))
  (global $outputOffset i32 (i32.const 512))
  (global $stop i32 (i32.const 255))
  ;;
  ;; Output the space-separated list of proteins specified by the space-separated list of codons
  ;;
  ;; @param {i32} $inputOffset - offset of the codon list in linear memory
  ;; @param {i32} $inputLength - length of the codon list in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the protein list in linear memory
  ;;
  (func (export "translate") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $inputPos i32)
    (local $key i32)
    (local $index i32)
    (local $chars i32)
    (local $outputLength i32)
    (if (i32.eqz (local.get $inputLength)) (then (return (global.get $outputOffset) (i32.const 0))))
    (loop $codons
      (local.set $chars (i32.and (i32.load (i32.add (local.get $inputOffset) (local.get $inputPos))) (global.get $triByte)))
      (local.set $index (i32.const 0))
      (loop $findProtein
        (local.set $key (i32.load (i32.add (global.get $keysOffset) (i32.shl (local.get $index) (i32.const 2)))))
        (if (i32.eq (local.get $chars) (i32.and (local.get $key) (global.get $triByte))) (then
          (local.set $key (i32.shr_u (local.get $key) (i32.const 24)))
          (if (i32.eq (local.get $key) (global.get $stop)) (then
            (return (global.get $outputOffset) (local.get $outputLength))))
          (local.set $key(i32.load16_u (i32.shl (local.get $key) (i32.const 1))))
          (memory.copy 
            (i32.add (global.get $outputOffset) (local.get $outputLength))
            (i32.and (local.get $key) (i32.const 255))
            (i32.shr_u (local.get $key) (i32.const 8)))
          (local.set $outputLength (i32.add (local.get $outputLength)
            (i32.shr_u (local.get $key) (i32.const 8))))
          (local.set $index (i32.sub (global.get $stop) (i32.const 1)))
        ))
        (local.set $index (i32.add (local.get $index) (i32.const 1)))
        (if (i32.lt_u (local.get $index) (global.get $keysLength))
        (then (br $findProtein)) 
        (else (if (i32.ne (local.get $index) (global.get $stop))
        (then (return (i32.const -1) (i32.const 0)))))))
      (local.set $inputPos (i32.add (local.get $inputPos) (i32.const 3)))
    (br_if $codons (i32.lt_u (local.get $inputPos) (local.get $inputLength))))
    (global.get $outputOffset) (local.get $outputLength)
  )
)


