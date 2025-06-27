(module
  (memory (export "mem") 1)

  (global $tableOffset i32 (i32.const 0))

  ;;
  ;; Calculate the price of shopping basket of books
  ;;
  ;; @param {i32} basketOffset - offset of input u32[] array
  ;; @param {i32} basketLength - length of input u32[] array in elements
  ;;
  ;; @return {i32} - price of shopping basket
  ;;
  (func (export "total") (param $basketOffset i32) (param $basketLength i32) (result i32)
    (local $stop i32)
    (local $inputPtr i32)
    (local $tablePtr i32)
    (local $i i32)
    (local $j i32)
    (local $tableI i32)
    (local $tableJ i32)
    (local $one i32)
    (local $two i32)
    (local $three i32)
    (local $four i32)
    (local $five i32)
    (local $adjustment i32)

    (local.set $stop (i32.add (local.get $basketOffset)
                              (i32.mul (local.get $basketLength)
                                       (i32.const 4))))
    (local.set $inputPtr (local.get $basketOffset))

    (memory.fill (global.get $tableOffset) (i32.const 0) (i32.const 20))

    (loop $read
      (if (i32.ne (local.get $inputPtr) (local.get $stop)) (then
        (local.set $tablePtr (i32.add (global.get $tableOffset)
                                      (i32.mul (i32.sub (i32.load (local.get $inputPtr))
                                                        (i32.const 1))
                                               (i32.const 4))))
        (i32.store (local.get $tablePtr) (i32.add (i32.load (local.get $tablePtr))
                                                  (i32.const 1)))
        (local.set $inputPtr (i32.add (local.get $inputPtr)
                                      (i32.const 4)))
        (br $read)
      ))
    )

    (local.set $i (i32.const 4))
    (loop $sortOuter
      (if (i32.lt_u (local.get $i) (i32.const 20)) (then
        (local.set $tableI (i32.load (i32.add (global.get $tableOffset)
                                              (local.get $i))))
        (local.set $j (local.get $i))

        (loop $sortInner
          (local.set $j (i32.sub (local.get $j)
                                 (i32.const 4)))
          (if (i32.ge_s (local.get $j) (i32.const 0)) (then
            (local.set $tableJ (i32.load (i32.add (global.get $tableOffset)
                                                  (local.get $j))))
            (if (i32.ge_u (local.get $tableJ) (local.get $tableI)) (then
              (i32.store (i32.add (global.get $tableOffset)
                                  (i32.add (local.get $j)
                                           (i32.const 4)))
                         (local.get $tableJ))
              (br $sortInner)
            ))
          ))
        )

        (i32.store (i32.add (global.get $tableOffset)
                            (i32.add (local.get $j)
                                     (i32.const 4)))
                   (local.get $tableI))

        (local.set $i (i32.add (local.get $i)
                               (i32.const 4)))
        (br $sortOuter)
      ))
    )

    (local.set $five (i32.load (i32.add (global.get $tableOffset)
                                        (i32.const 0))))
    (local.set $four (i32.load (i32.add (global.get $tableOffset)
                                        (i32.const 4))))
    (local.set $three (i32.load (i32.add (global.get $tableOffset)
                                         (i32.const 8))))
    (local.set $two (i32.load (i32.add (global.get $tableOffset)
                                       (i32.const 12))))
    (local.set $one (i32.load (i32.add (global.get $tableOffset)
                                       (i32.const 16))))

    (local.set $one (i32.sub (local.get $one)
                             (local.get $two)))
    (local.set $two (i32.sub (local.get $two)
                             (local.get $three)))
    (local.set $three (i32.sub (local.get $three)
                               (local.get $four)))
    (local.set $four (i32.sub (local.get $four)
                              (local.get $five)))

    (local.set $adjustment (local.get $three))
    (if (i32.lt_u (local.get $five) (local.get $three)) (then
      (local.set $adjustment (local.get $five))
    ))

    (local.set $three (i32.sub (local.get $three)
                               (local.get $adjustment)))
    (local.set $five (i32.sub (local.get $five)
                              (local.get $adjustment)))
    (local.set $four (i32.add (local.get $four)
                              (i32.mul (local.get $adjustment)
                                       (i32.const 2))))

    (local.set $one (i32.mul (local.get $one)
                             (i32.const 800)))
    (local.set $two (i32.mul (local.get $two)
                             (i32.const 1520)))
    (local.set $three (i32.mul (local.get $three)
                               (i32.const 2160)))
    (local.set $four (i32.mul (local.get $four)
                              (i32.const 2560)))
    (local.set $five (i32.mul (local.get $five)
                              (i32.const 3000)))

    (return (i32.add (local.get $one)
                     (i32.add (i32.add (local.get $two)
                                       (local.get $three))
                              (i32.add (local.get $four)
                                       (local.get $five)))))
  )
)
