# Hints

Linear memory is byte-addressable, but `i32` has a width of four bytes.

"The `memory.grow` instruction is used to grow a linear memory. The instruction grows memory by a given delta and returns the previous size, or -1 if enough memory cannot be allocated. Both instructions operate in units of page size."

From https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory

"A memory instance... holds a vector of bytes. The length of the vector always is a multiple of the WebAssembly page size, which is defined to be the constant 65536"

From https://webassembly.github.io/spec/core/exec/runtime.html#page-size
