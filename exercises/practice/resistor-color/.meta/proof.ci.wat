(module
  (memory (export "mem") 1)

  (data (i32.const 100) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  (func (export "colors") (result i32 i32)
    (return (i32.const 100) (i32.const 58))
  )

  (func $initialize
    ;; {str:(i32, i32), val: i32}[]
    ;; Black
    (i32.store (i32.const 200) (i32.const 100))
    (i32.store (i32.const 204) (i32.const 5))
    (i32.store (i32.const 208) (i32.const 0))
    ;; Brown
    (i32.store (i32.const 212) (i32.const 106))
    (i32.store (i32.const 216) (i32.const 5))
    (i32.store (i32.const 220) (i32.const 1))
    ;; Red
    (i32.store (i32.const 224) (i32.const 112))
    (i32.store (i32.const 228) (i32.const 3))
    (i32.store (i32.const 232) (i32.const 2))
    ;; Orange
    (i32.store (i32.const 236) (i32.const 116))
    (i32.store (i32.const 240) (i32.const 6))
    (i32.store (i32.const 244) (i32.const 3))
    ;; Yellow
    (i32.store (i32.const 248) (i32.const 123))
    (i32.store (i32.const 252) (i32.const 6))
    (i32.store (i32.const 256) (i32.const 4))
    ;; Green
    (i32.store (i32.const 260) (i32.const 130))
    (i32.store (i32.const 264) (i32.const 5))
    (i32.store (i32.const 268) (i32.const 5))
    ;; Blue
    (i32.store (i32.const 272) (i32.const 136))
    (i32.store (i32.const 276) (i32.const 4))
    (i32.store (i32.const 280) (i32.const 6))
    ;; Violet
    (i32.store (i32.const 284) (i32.const 141))
    (i32.store (i32.const 288) (i32.const 6))
    (i32.store (i32.const 292) (i32.const 7))
    ;; Grey
    (i32.store (i32.const 296) (i32.const 148))
    (i32.store (i32.const 300) (i32.const 4))
    (i32.store (i32.const 304) (i32.const 8))
    ;; White
    (i32.store (i32.const 308) (i32.const 153))
    (i32.store (i32.const 312) (i32.const 5))
    (i32.store (i32.const 316) (i32.const 9))

    ;; Base, element size, and element count
    (i32.store (i32.const 400) (i32.const 200))
    (i32.store (i32.const 404) (i32.const 12))
    (i32.store (i32.const 408) (i32.const 10))
  )

  (start $initialize)

  ;; Returns 1 if bytes in a and b match
  (func $memcmp (param $aOffset i32) (param $aLen i32) (param $bOffset i32) (param $bLen i32) (result i32)
    (local $i i32)
    (local.set $i (i32.const 0))
    
    ;; If lengths don't match, early out and return false
    (if (i32.ne (local.get $aLen) (local.get $bLen)) (then (return (i32.const 0))))

    (if (i32.gt_u (local.get $aLen) (i32.const 0)) (then 

      (loop
        ;; If a byte doesn't match, return false
        (if (i32.ne 
          (i32.load8_u(i32.add (local.get $aOffset) (local.get $i))) 
          (i32.load8_u(i32.add (local.get $bOffset) (local.get $i)))
        ) (then
          (return (i32.const 0))
        ))

        (br_if 0 (i32.lt_u 
          (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (local.get $aLen)
        ))
      )
    ))

    ;; If all characters matched, return true
    (return (i32.const 1))
  )
  
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (local $i i32)
    (local $arrayBase i32)
    (local $arrayElemSize i32)
    (local $arrayLength i32)
    (local $currentBase i32)
    (local $currentLen i32)
    (local $currentVal i32)

    (local.set $arrayBase (i32.load (i32.const 400)))
    (local.set $arrayElemSize (i32.load (i32.const 404)))
    (local.set $arrayLength (i32.load (i32.const 408)))
    (local.set $i (i32.const 0))

    (loop
      ;; Unpack the "struct" {str:(i32, i32), val: i32} using offsets
      (local.set $currentBase (i32.load (i32.add (local.get $arrayBase) (i32.mul (local.get $arrayElemSize) (local.get $i)))))
      (local.set $currentLen (i32.load (i32.add (i32.add (local.get $arrayBase) (i32.mul (local.get $arrayElemSize) (local.get $i))) (i32.const 4))))
      (local.set $currentVal (i32.load (i32.add (i32.add (local.get $arrayBase) (i32.mul (local.get $arrayElemSize) (local.get $i))) (i32.const 8))))

      ;; If the input string matches this element, return the value of the element
      (if (call $memcmp (local.get $offset) (local.get $len) (local.get $currentBase) (local.get $currentLen)) (then
        (return (local.get $currentVal))
      ))

      (br_if 0 (i32.lt_u (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $arrayLength)))
    )
  
    (return (i32.const -1))
  )
)
