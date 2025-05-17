## Input format

The input will be in the format of a string. To keep this exercise beginner-friendly, you need not expect numbers with multiple digits.

Bytes 64-191 of the linear memory are reserved for the input string.

## Output format

The output is expected in pairs of row and column as u8 directly concatenated.

For example, if there are three saddle points

row: 2, column: 1
row: 2, column: 2
row: 2, column: 3

then the expected output would be the u8 values `2, 1, 2, 2, 2, 3`

