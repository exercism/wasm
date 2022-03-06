## Reserved Addresses

The buffer for the input string uses bytes 64 - 196 of linear memory.

You may modify this buffer in place if you wish to avoid additional memory allocations

## Hints

WebAssembly lacks the sort of string library typically found in higher level languages. This means that you must manually implement functionality to:

- Check if a character is uppercase
- Check if a character is lowercase
- Check if a character is a letter
- Convert a lowercase letter to an uppercase letter

We encode characters in UTF-8 and limit input to ASCII character encoding.

Reference: https://en.wikipedia.org/wiki/ASCII
