# Hints

`i32` has a width of four bytes.

"A memory instance... holds a vector of bytes. The length of the vector always is a multiple of the WebAssembly page size, which is defined to be the constant 65536"

[WebAssembly Specification: Memory Instances](https://webassembly.github.io/spec/core/exec/runtime.html#page-size)

"The `memory.size` instruction returns the current size of a memory. The `memory.grow` instruction grows memory by a given delta and returns the previous size, or -1 if enough memory cannot be allocated. Both instructions operate in units of page size."

[WebAssembly Specification: Memory Instructions](https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory)

Further References:

- [memory.size at MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Memory/Size)
- [memory.grow at MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Memory/Grow)
