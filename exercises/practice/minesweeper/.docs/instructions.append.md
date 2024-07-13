
## Minefield format

The minefield is represented as a string, with a newline character at the end of each row.

An example would be `"   \n * \n   \n"`

## Reserved Memory

The buffer for the input string uses bytes 64-319 of linear memory.

The input string can be modified in place if desired.
