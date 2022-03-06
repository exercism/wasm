## Reserved Addresses

The buffer for the first string uses bytes 1024-2047 of linear memory.
The buffer for the second string uses bytes 2048-3075 of linear memory.

You should not have to modify these buffer or allocate additional memory

## Hints

WebAssembly lacks the sort of string library typically found in higher level languages. This means that you must manually implement functionality to:

- Check if a character is uppercase
- Check if a character is lowercase
- Check if a character is a letter
- Convert a lowercase letter to an uppercase letter

We encode characters in UTF-8 and limit input to ASCII character encoding.

Reference: https://en.wikipedia.org/wiki/ASCII
