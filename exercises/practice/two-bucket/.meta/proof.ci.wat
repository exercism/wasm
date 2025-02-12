(module
  (func $gcd (param $a i32) (param $b i32) (result i32)
    (if (i32.eqz (local.get $b)) (then (return (local.get $a))))
    (call $gcd (local.get $b) (i32.rem_s (local.get $a) (local.get $b)))
  )

  ;;
  ;; Get to the goal using two buckets
  ;;
  ;; @param {i32} $bucketOne - capacity of the first bucket
  ;; @param {i32} $bucketTwo - capacity of the second bucket
  ;; @param {i32} $goal - level to achieve by filling / emptying the buckets
  ;; @param {i32} $starterBucket - bucket to start with (1 / 2)
  ;;
  ;; @returns {(i32,i32,i32)} number of moves, winning bucket, level of other bucket;
  ;;                          if unsolvable, make sure moves is -1
  ;;
  (func (export "twoBucket") (param $bucketOne i32) (param $bucketTwo i32)
  (param $goal i32) (param $starterBucket i32) (result i32 i32 i32)
    (local $moves i32)
    (local $levelOne i32)
    (local $levelTwo i32)
    (local $diff i32)
    (if (i32.eq (local.get $starterBucket) (i32.const 2)) (then (local.set $diff (local.get $bucketTwo))
        (local.set $bucketTwo (local.get $bucketOne)) (local.set $bucketOne (local.get $diff))))
    (if (i32.or (i32.and (i32.gt_s (local.get $goal) (local.get $bucketOne))
      (i32.gt_s (local.get $goal) (local.get $bucketTwo)))
      (i32.ne (i32.rem_u (local.get $goal) (call $gcd (local.get $bucketOne) (local.get $bucketTwo))) (i32.const 0)))
      (then (return (i32.const -1) (i32.const 0) (i32.const 0))))
    (loop $move
      (local.set $moves (i32.add (local.get $moves) (i32.const 1)))
      (if (i32.eq (local.get $levelTwo) (local.get $bucketTwo)) (then (local.set $levelTwo (i32.const 0)))
        (else (if (i32.eqz (local.get $levelOne)) (then (local.set $levelOne (local.get $bucketOne)))
        (else (if (i32.eq (local.get $bucketTwo) (local.get $goal)) (then (local.set $levelTwo (local.get $goal)))
        (else (local.set $diff (i32.sub (local.get $bucketTwo) (local.get $levelTwo)))
          (local.set $diff (select (local.get $levelOne) (local.get $diff) (i32.lt_s (local.get $levelOne) (local.get $diff))))
          (local.set $levelOne (i32.sub (local.get $levelOne) (local.get $diff))
          (local.set $levelTwo (i32.add (local.get $levelTwo) (local.get $diff))))))))))
      (if (i32.eq (local.get $levelOne) (local.get $goal))
        (then (return (local.get $moves) (local.get $starterBucket) (local.get $levelTwo))))
      (if (i32.eq (local.get $levelTwo) (local.get $goal))
        (then (return (local.get $moves) (i32.sub (i32.const 3) (local.get $starterBucket)) (local.get $levelOne))))
      (if (i32.gt_u (local.get $moves) (i32.const 1000)) (then (return (i32.const -1) (local.get $levelOne) (local.get $levelTwo))))
    (br $move))
    (unreachable)
  )
)
