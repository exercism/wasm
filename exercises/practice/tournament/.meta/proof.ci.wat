(module
  (memory (export "mem") 1)

  (global $outputOffset i32 (i32.const 2048))
  (global $headlineOffset i32 (i32.const 512))
  (global $templateOffset i32 (i32.const 568))
  (global $lineLength i32 (i32.const 56))
  ;; team roster u64[nameOffset: i16, nameLength: u8, played: u8, won: u8, draw: u8, loss: u8, points: u8][]
  (global $rosterOffset i32 (i32.const 1024))
  (global $semicolon i32 (i32.const 59))
  (global $linebreak i32 (i32.const 10))
  (global $win i32 (i32.const 119))
  (global $draw i32 (i32.const 100))
  (global $loss i32 (i32.const 108))
  (global $zero i32 (i32.const 48))
  (global $mpPos i32 (i32.const 34))
  (global $wPos i32 (i32.const 39))
  (global $dPos i32 (i32.const 44))
  (global $lPos i32 (i32.const 49))
  (global $pPos i32 (i32.const 54))

  (data (i32.const 512) "Team                           | MP |  W |  D |  L |  P\n                               |    |    |    |    |   \n")
  (data (i32.const 1024) "\00\00\00\00\00\00\00\00\00")

  ;;
  ;; Compare two strings
  ;;
  ;; @param {i32} $offsetA - offset of the first string in linear memory
  ;; @param {i32} $lengthA - length of the first string in linear memory
  ;; @param {i32} $offsetB - offset of the second string in linear memory
  ;; @param {i32} $lengthB - length of the second string in linear memory
  ;;
  ;; @returns {i32} - difference of the first deviation or zero if there is none
  ;;
  (func $strcmp (export "strcmp") (param $offsetA i32) (param $lengthA i32) (param $offsetB i32) (param $lengthB i32) (result i32)
    (local $pos i32)
    (local $diff i32)
    (if (i32.or (i32.eqz (local.get $lengthA)) (i32.eqz (local.get $lengthB))) (then
      (return (i32.sub (local.get $lengthA) (local.get $lengthB)))))
    (local.set $pos (i32.const -1))
    (loop $chars
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
      (if (i32.or (i32.gt_u (local.get $pos) (local.get $lengthA))
        (i32.gt_u (local.get $pos) (local.get $lengthB))) (then
          (return (i32.sub (local.get $lengthA) (local.get $lengthB)))))
      (local.set $diff (i32.sub (i32.load8_u (i32.add (local.get $offsetB) (local.get $pos)))
        (i32.load8_u (i32.add (local.get $offsetA) (local.get $pos)))))
    (br_if $chars (i32.eqz (local.get $diff))))
    (local.get $diff)
  )

  ;;
  ;; get a team from the roster or add it if not present
  ;;
  ;; @param {i32} $inputOffset - offset of the team name in linear memory
  ;; @param {i32} $inputLength - length of the team name in linear memory
  ;;
  ;; @returns {i32} - position in teams roster
  ;;
  (func $getTeam (param $inputOffset i32) (param $inputLength i32) (result i32)
    (local $pos i32)
    (local $offset i32)
    (local $length i32)
    (local.set $pos (i32.const -1))
    (loop $roster
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
      (local.set $offset (i32.load16_u (i32.add (global.get $rosterOffset)
        (i32.shl (local.get $pos) (i32.const 3)))))
      (local.set $length (i32.load8_u (i32.add (global.get $rosterOffset) 
        (i32.add (i32.shl (local.get $pos) (i32.const 3)) (i32.const 2)))))
      ;; none found
      (if (i32.eqz (local.get $offset)) (then
        (local.set $offset (local.get $inputOffset))
        (local.set $length (local.get $inputLength))
        ;; store name offset
        (i32.store16 (i32.add (global.get $rosterOffset)
          (i32.shl (local.get $pos) (i32.const 3))) (local.get $inputOffset))
        ;; store name length
        (i32.store8 (i32.add (i32.add (global.get $rosterOffset)
          (i32.shl (local.get $pos) (i32.const 3))) (i32.const 2))
            (local.get $inputLength))
        ;; write empty game data + next empty offset / length
        (memory.fill (i32.add (i32.add (global.get $rosterOffset)
          (i32.shl (local.get $pos) (i32.const 3))) (i32.const 3))
          (i32.const 0) (i32.const 8))))
      ;; loop if team not found at current pos
    (br_if $roster (call $strcmp (local.get $offset) (local.get $length)
      (local.get $inputOffset) (local.get $inputLength))))
    (local.get $pos)
  )

  ;;
  ;; Tally the tournament results into a formatted table
  ;;
  ;; @param {i32} $inputOffset - offset of the tournament results in linear memory
  ;; @param {i32} $inputLength - length of the tournament results in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the formatted tally in linear memory
  ;;
  (func (export "tournamentTally") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $char i32)
    (local $last i32)
    (local $pos i32)
    (local $outputLength i32)
    (local $team i32)
    (local $teamA i32)
    (local $teamB i32)
    (local $tmp i64)
    ;; read results
    (local.set $teamA (i32.const -1))
    (local.set $teamB (i32.const -1))
    (loop $read 
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $pos))))
      ;; semicolon after each team name
      (if (i32.eq (local.get $char) (global.get $semicolon)) (then
        (local.set $team (call $getTeam (i32.add (local.get $inputOffset) (local.get $last))
          (i32.sub (local.get $pos) (local.get $last))))
        (if (i32.eq (local.get $teamA) (i32.const -1))
          (then (local.set $teamA (local.get $team)))
          (else (local.set $teamB (local.get $team))))
        (local.set $last (i32.add (local.get $pos) (i32.const 1)))))
      ;; line break after each match
      (if (i32.eq (local.get $char) (global.get $linebreak)) (then
        (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $last))))
        ;; increase number of matches played for both teams
        (local.set $team (i32.add (global.get $rosterOffset)
          (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 3))))
        (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
        (local.set $team (i32.add (global.get $rosterOffset)
          (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 3))))
        (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
        ;; increase wins/draws/losses
        (if (i32.eq (local.get $char) (global.get $win)) (then
          ;; teamA won
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 4))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamA gains 3 points
          (local.set $team (i32.add (local.get $team) (i32.const 3)))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 3)))
          ;; teamB lost
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 6))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
        ))
        (if (i32.eq (local.get $char) (global.get $draw)) (then
          ;; teamA draw
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 5))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamA gains 1 point
          (local.set $team (i32.add (local.get $team) (i32.const 2)))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamB draw
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 5))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamB gains 1 point
          (local.set $team (i32.add (local.get $team) (i32.const 2)))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
        ))
        (if (i32.eq (local.get $char) (global.get $loss)) (then
          ;; teamA lost
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 6))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamB won
          (local.set $team (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 4))))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 1)))
          ;; teamB gains 3 points
          (local.set $team (i32.add (local.get $team) (i32.const 3)))
          (i32.store8 (local.get $team) (i32.add (i32.load8_u (local.get $team)) (i32.const 3)))
        ))
        ;; reset teams for next line
        (local.set $teamA (i32.const -1))
        (local.set $teamB (i32.const -1))
        (local.set $last (i32.add (local.get $pos) (i32.const 1)))
      ))
      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))
    (br_if $read (i32.lt_u (local.get $pos) (local.get $inputLength))))
    ;; sort teams: simple exchange sort by points / name
    (local.set $teamA (i32.const 0))
    (loop $sortA
      (local.set $teamB (i32.add (local.get $teamA) (i32.const 1)))
      (loop $sortB
        ;; point difference a - b
        (local.set $char (i32.sub (i32.load8_u (i32.add (global.get $rosterOffset)
          (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 7))))
          (i32.load8_u (i32.add (global.get $rosterOffset)
          (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 7))))))
        ;; no point difference - sort by name instead
        (if (i32.eqz (local.get $char)) (then
          (local.set $char (call $strcmp 
            ;; offsetA
            (i32.load16_u (i32.add (global.get $rosterOffset)
              (i32.shl (local.get $teamA) (i32.const 3))))
            ;; lengthA
            (i32.load16_u (i32.add (global.get $rosterOffset)
              (i32.add (i32.shl (local.get $teamA) (i32.const 3)) (i32.const 2))))
            ;; offsetB
            (i32.load16_u (i32.add (global.get $rosterOffset)
              (i32.shl (local.get $teamB) (i32.const 3))))
            ;; lengthB
            (i32.load16_u (i32.add (global.get $rosterOffset)
              (i32.add (i32.shl (local.get $teamB) (i32.const 3)) (i32.const 2))))))))
        ;; switch if b should be before a
        (if (i32.lt_s (local.get $char) (i32.const 0)) (then
          ;; save teamA to tmp
          (local.set $tmp (i64.load (i32.add (global.get $rosterOffset)
            (i32.shl (local.get $teamA) (i32.const 3)))))
          ;; move teamB to teamA's offset
          (i64.store (i32.add (global.get $rosterOffset)
            (i32.shl (local.get $teamA) (i32.const 3)))
            (i64.load (i32.add (global.get $rosterOffset)
              (i32.shl (local.get $teamB) (i32.const 3)))))
          ;; write saved teamA at teamB's offset
          (i64.store (i32.add (global.get $rosterOffset)
            (i32.shl (local.get $teamB) (i32.const 3))) (local.get $tmp))))
        (local.set $teamB (i32.add (local.get $teamB) (i32.const 1)))
      (br_if $sortB (i32.load16_u (i32.add (global.get $rosterOffset)
        (i32.shl (local.get $teamB) (i32.const 3))))))
      (local.set $teamA (i32.add (local.get $teamA) (i32.const 1)))
    (br_if $sortA (i32.load16_u (i32.add (global.get $rosterOffset)
      (i32.shl (local.get $teamA) (i32.const 3))))))
    ;; header
    (memory.copy (global.get $outputOffset) (global.get $headlineOffset) (global.get $lineLength))
    (local.set $outputLength (i32.add (local.get $outputLength) (global.get $lineLength)))
    ;; write team lines
    (local.set $team (i32.const 0))
    (loop $write
      ;; read offset + length
      (local.set $pos (i32.load16_u (i32.add (global.get $rosterOffset)
        (i32.shl (local.get $team) (i32.const 3)))))
      (local.set $last (i32.load8_u (i32.add (global.get $rosterOffset)
        (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 2)))))
      (if (local.get $pos) (then
        ;; write line template
        (memory.copy (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $templateOffset) (global.get $lineLength))
        ;; write name
        (memory.copy (i32.add (global.get $outputOffset) (local.get $outputLength))
          (local.get $pos) (local.get $last))
        ;; write matches played
        (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $mpPos)) (i32.add (i32.load8_u (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 3)))) (global.get $zero)))
        ;; write wins
        (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $wPos)) (i32.add (i32.load8_u (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 4)))) (global.get $zero)))
        ;; write draws
        (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $dPos)) (i32.add (i32.load8_u (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 5)))) (global.get $zero)))
        ;; write losses
        (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $lPos)) (i32.add (i32.load8_u (i32.add (global.get $rosterOffset)
            (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 6)))) (global.get $zero)))
        ;; write points
        (local.set $last (i32.load8_u (i32.add (global.get $rosterOffset)
          (i32.add (i32.shl (local.get $team) (i32.const 3)) (i32.const 7)))))
        (if (i32.gt_u (local.get $last) (i32.const 9)) (then
          (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
            (i32.sub (global.get $pPos) (i32.const 1))) (i32.add 
              (i32.div_u (local.get $last) (i32.const 10)) (global.get $zero)))))
        (i32.store8 (i32.add (i32.add (global.get $outputOffset) (local.get $outputLength))
          (global.get $pPos)) (i32.add (i32.rem_u (local.get $last) (i32.const 10)) (global.get $zero)))
        ;; add line to output length
        (local.set $outputLength (i32.add (local.get $outputLength) (global.get $lineLength)))))
    (local.set $team (i32.add (local.get $team) (i32.const 1)))
    (br_if $write (local.get $pos)))
    (global.get $outputOffset) (i32.sub (local.get $outputLength) (i32.const 1))
  )
)