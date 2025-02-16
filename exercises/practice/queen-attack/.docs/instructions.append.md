# Instructions append

A queen must be placed on a valid position on the board.
Two queens cannot share the same position.

The queens shown below are at their [default starting positions](https://en.wikipedia.org/wiki/Rules_of_chess#Initial_setup). That's the 1st rank (row 7) for the white queen and the 8th rank (row 0) for the black queen. Both queens start in the d file (column 3).

```text
  a b c d e f g h
8 _ _ _ B _ _ _ _ 8
7 _ _ _ _ _ _ _ _ 7
6 _ _ _ _ _ _ _ _ 6
5 _ _ _ _ _ _ _ _ 5
4 _ _ _ _ _ _ _ _ 4
3 _ _ _ _ _ _ _ _ 3
2 _ _ _ _ _ _ _ _ 2
1 _ _ _ W _ _ _ _ 1
  a b c d e f g h
```

# Positions argument

The function will receive only a single unsigned 32bit number as argument. Both rows and columns are encoded into it:

- The chess notation files a..h become zero-indexed columns 0..7
- The chess notation ranks 8..1 become zero-indexed rows 0..7

```
[            32bit             ]
[ 8bit ][ 8bit ][ 8bit ][ 8bit ]
   ^       ^       ^       ^
   |       |       |       +---- black row
   |       |       +------------ black column
   |       +-------------------- white row
   +---------------------------- white column
```

So the aforementioned positions white D1 and black D8 would result in the numbers white column 3, white row 7, black column 3, black row 0; as binary number, this would be expressed as

`00000011 00000111 00000011 00000000`

So the `$positions` argument would be 50791168.

You can use integer division or bit shifting and division remainder or bitwise and to get at every one value.
