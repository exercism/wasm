# Instructions append

## Reserved Memory

The buffer for the input string uses bytes 64-191 of linear memory.

## Input format

The input comes formatted as a single string of three lines with a line break at the end of each. Crosses and Naughts will always be upper case `X` and `O`.

So the board

```
X··
OXO
XOX
```
will be encoded as

```
"X  \nOXO\nXOX\n"
```
