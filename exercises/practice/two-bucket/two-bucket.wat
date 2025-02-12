(module
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
    (i32.const -1) (i32.const 0) (i32.const 0)
  )
)
