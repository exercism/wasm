# Instruction append

## Input format

Each domino is stored as two consecutive bytes in linear memory, one byte for each half.

For example, stones `[2|1]`, `[2|3]` and `[1|3]` are represented as the byte array `[ 0x02, 0x01, 0x02, 0x03, 0x01, 0x03 ]`

## Reserved Memory

The buffer for the input dominoes uses bytes 256-511 of linear memory.
