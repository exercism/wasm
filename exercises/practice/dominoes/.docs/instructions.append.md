# Instruction append

## Input format

Each stone is represented in a single byte: 4 bits for each half.

For example, stones `[2|1]`, `[2|3]` and `[1|3]` are represented as the byte array `[ 0x21, 0x23, 0x13 ]`

## Reserved Memory

The buffer for the input dominoes uses bytes 256-511 of linear memory.

~~~~exercism/note
Half a byte is known as a [nibble][].

[nibble]: https://en.wikipedia.org/wiki/Nibble
~~~~
