(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 0))
  (global $zeroCodePoint i32 (i32.const 48))
  (global $nineCodePoint i32 (i32.const 57))

  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)

    (local $inputPointer i32)
    (local $outputPointer i32)
    (local $number i32)
    (local $currentChar i32)

    (i32.eqz (local.get $inputLength))
    if
      (return
        (global.get $outputOffset)
        (i32.const 0))
    end

    (local.set $inputPointer (local.get $inputOffset))
    (local.set $number (i32.const 0))
    (local.set $outputPointer (global.get $outputOffset))
    (local.set $currentChar (i32.const 0))

    loop $LOOP
      (i32.eq
        (local.get $currentChar)
        (i32.load8_u (local.get $inputPointer)))
      if
        (local.set $number
          (i32.add
            (local.get $number)
            (i32.const 1)))
      else
        (i32.eqz (local.get $currentChar))
        if
          (local.set $currentChar
            (i32.load8_u (local.get $inputPointer)))

          (local.set $number (i32.const 1))
        else
          (i32.gt_u
            (local.get $number)
            (i32.const 1))
          if
            (call $numberToString
              (local.get $outputPointer)
              (local.get $number))

            (local.set $outputPointer
              (i32.add
                (local.get $outputPointer)))
          end

          (i32.store8
            (local.get $outputPointer)
            (local.get $currentChar))

          (local.set $outputPointer
            (i32.add
              (local.get $outputPointer)
              (i32.const 1)))

          (local.set $currentChar
            (i32.load8_u (local.get $inputPointer)))

          (local.set $number (i32.const 1))
        end
      end

      (local.set $inputPointer
        (i32.add
          (local.get $inputPointer)
          (i32.const 1)))

      (i32.lt_u
        (local.get $inputPointer)
        (i32.add
          (local.get $inputOffset)
          (local.get $inputLength)))
      if
        br $LOOP
      end
    end

    (i32.gt_u
      (local.get $number)
      (i32.const 1))
    if
      (call $numberToString
        (local.get $outputPointer)
        (local.get $number))

      (local.set $outputPointer
        (i32.add
          (local.get $outputPointer)))
    end

    (i32.store8
      (local.get $outputPointer)
      (local.get $currentChar))

    (local.set $outputPointer
      (i32.add
        (local.get $outputPointer)
        (i32.const 1)))

    (return (global.get $outputOffset)
            (i32.sub
              (local.get $outputPointer)
              (global.get $outputOffset)))
  )

  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)

    (local $inputPointer i32)
    (local $outputPointer i32)
    (local $currentNumber i32)

    (i32.eqz (local.get $inputLength))
    if
      (return
        (global.get $outputOffset)
        (i32.const 0))
    end

    (local.set $inputPointer (local.get $inputOffset))
    (local.set $outputPointer (global.get $outputOffset))
    (local.set $currentNumber (i32.const 1))

    loop $LOOP
      (call $isDigit (local.get $inputPointer))
      if
        (call $consumeNumber (local.get $inputPointer))
        (local.set $inputPointer)
        (local.set $currentNumber)
      end

      (local.set $outputPointer
        (call $repeat
          (local.get $outputPointer)
          (i32.load8_u (local.get $inputPointer))
          (local.get $currentNumber)))

      (local.set $inputPointer
        (i32.add
          (local.get $inputPointer)
          (i32.const 1)))
      (local.set $currentNumber (i32.const 1))

      (i32.lt_u
        (local.get $inputPointer)
        (i32.add
          (local.get $inputOffset)
          (local.get $inputLength)))
      if
        br $LOOP
      end
    end

    (return
      (global.get $outputOffset)
      (i32.sub
        (local.get $outputPointer)
        (global.get $outputOffset)))
  )

  (func $repeat (param $outputOffset i32) (param $codePoint i32) (param $times i32) (result i32)
    loop $LOOP
      (i32.store8
        (local.get $outputOffset)
        (local.get $codePoint))

      (local.set $times
        (i32.sub
          (local.get $times)
          (i32.const 1)))
      (local.set $outputOffset
        (i32.add
          (local.get $outputOffset)
          (i32.const 1)))

      (i32.gt_u
        (local.get $times)
        (i32.const 0))
      if
        br $LOOP
      end
    end

    (return (local.get $outputOffset))
  )

  (func $consumeNumber (param $inputOffset i32) (result i32 i32)
    (local $inputPointer i32)
    (local $number i32)

    (local.set $inputPointer (local.get $inputOffset))
    (local.set $number (i32.const 0))

    loop $LOOP
      (local.set $number
        (i32.add
          (i32.mul
            (local.get $number)
            (i32.const 10))
          (call $codePointToDigit (i32.load8_u (local.get $inputPointer)))))

      (local.set $inputPointer
        (i32.add
          (local.get $inputPointer)
          (i32.const 1)))

      (call $isDigit (local.get $inputPointer))
      if
        br $LOOP
      end
    end

    (return
      (local.get $number)
      (local.get $inputPointer))
  )

  (func $pow (param $base i32) (param $power i32) (result i32)
    (local $number i32)

    (i32.eqz (local.get $power))
    if
      (return (i32.const 1))
    end

    (local.set $number (local.get $base))

    (i32.eq
      (local.get $power)
      (i32.const 1))
    if
      (return (local.get $number))
    end

    loop $LOOP
      (local.set $number
        (i32.mul
          (local.get $number)
          (local.get $number)))

      (local.set $power
        (i32.sub
          (local.get $power)
          (i32.const 1)))

      (i32.gt_u
        (local.get $power)
        (i32.const 1))
      if
        br $LOOP
      end
    end

    (return (local.get $number))
  )

  (func $isDigit (param $inputOffset i32) (result i32)
    (i32.and
      (i32.ge_u
        (i32.load8_u (local.get $inputOffset))
        (global.get $zeroCodePoint))
      (i32.le_u
        (i32.load8_u (local.get $inputOffset))
        (global.get $nineCodePoint)))
  )

  (func $digitToCodePoint (param $digit i32) (result i32)
    (return
      (i32.add
        (local.get $digit)
        (global.get $zeroCodePoint)))
  )

  (func $codePointToDigit (param $codePoint i32) (result i32)
    (return
      (i32.sub
        (local.get $codePoint)
        (global.get $zeroCodePoint)))
  )

  (func $numberToString (param $outputOffset i32) (param $number i32)
    (result i32)
    (local $i i32)

    (local.set $i (local.get $outputOffset))

    loop $LOOP
      (i32.store8
        (local.get $i)
        (call $digitToCodePoint
          (i32.rem_u
            (local.get $number)
            (i32.const 10))))

      (local.set $number
        (i32.div_u
          (local.get $number)
          (i32.const 10)))
      (local.set $i
        (i32.add
          (local.get $i)
          (i32.const 1)))

      (i32.gt_u
        (local.get $number)
        (i32.const 0))
      if
        br $LOOP
      end
    end

    (call $reverseInPlace
      (local.get $outputOffset)
      (i32.sub
          (local.get $i)
          (local.get $outputOffset)))

    (return (i32.sub
              (local.get $i)
              (local.get $outputOffset)))
  )

  (func $reverseInPlace (param $offset i32) (param $length i32)
    (local $i i32)
    (local $mirrorI i32)
    (local $limit i32)
    (local $tmp i32)

    (i32.or
      (i32.eqz (local.get $length))
      (i32.eq
        (local.get $length)
        (i32.const 1)))
    if
      (return)
    end

    (local.set $i (local.get $offset))
    (local.set $limit
      (i32.add
        (local.get $offset)
        (i32.div_u
          (local.get $length)
          (i32.const 2))))

    loop $LOOP
      (local.set $tmp
        (i32.load8_u (local.get $i)))

      (local.set $mirrorI
        (i32.sub
          (i32.add
            (local.get $offset)
            (local.get $length))
          (i32.add
            (i32.const 1)
            (i32.sub
              (local.get $i)
              (local.get $offset)))))

      (i32.store8
        (local.get $i)
        (i32.load8_u (local.get $mirrorI)))

      (i32.store8
        (local.get $mirrorI)
        (local.get $tmp))

      (local.set $i
        (i32.add
          (local.get $i)
          (i32.const 1)))

      (i32.lt_u
        (local.get $i)
        (local.get $limit))
      if
        br $LOOP
      end
    end
  )
)
