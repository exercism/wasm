(module
	(memory (export "mem") 1)

	(global $Advance i32 (i32.const 65))
	(global $Left i32 (i32.const 76))
	(global $Right i32 (i32.const 82))

	;;
	;; evaluate robot placement after running instructions
	;;
	;; @param {i32} $direction - 0 = north, 1 = east, 2 = south, 3 = west
	;; @param {i32} $x - horizontal position
	;; @param {i32} $y - vertical position
	;; @param {i32} $offset - the offset of the instructions in linear memory
	;; @param {i32} $length - the length of the instructions in linear memory
	;;
	;; @returns {(i32,i32,i32)} direction, x and y after the instructions
	;;          are executed; direction is -1 on error
	;;
	(func (export "evaluate") (param $direction i32) (param $x i32) (param $y i32)
		(param $offset i32) (param $length i32) (result i32 i32 i32)
		(local $pos i32)
		(local $instruction i32)
		(loop $instructions
			(local.set $instruction (i32.load8_u
				(i32.add (local.get $offset) (local.get $pos))))
			(if (i32.eq (local.get $instruction) (global.get $Advance)) (then
				(local.set $x (i32.add (local.get $x) (i32.rem_s
					(i32.sub (i32.const 2) (local.get $direction)) (i32.const 2))))
				(local.set $y (i32.add (local.get $y) (i32.rem_s
					(i32.sub (i32.const 1) (local.get $direction)) (i32.const 2)))))
			(else (if (i32.eq (local.get $instruction) (global.get $Left)) (then
				(local.set $direction (i32.rem_u (i32.add (local.get $direction)
					(i32.const 3)) (i32.const 4))))
			(else (if (i32.eq (local.get $instruction) (global.get $Right)) (then ;; R
				(local.set $direction (i32.rem_u (i32.add (local.get $direction)
					(i32.const 1)) (i32.const 4))))
			(else (return (i32.const -1) (local.get $x) (local.get $y))))))))
			(local.set $pos (i32.add (local.get $pos) (i32.const 1)))
		(br_if $instructions (i32.lt_u (local.get $pos) (local.get $length))))
		(local.get $direction) (local.get $x) (local.get $y)
	)
)
