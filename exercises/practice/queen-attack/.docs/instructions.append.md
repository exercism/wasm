# Positions argument

The function will receive only a single unsigned 32bit number as argument which contains both the black and white columns and rows as a number from 0 to 7:

```
[            32bit             ]
[ 8bit ][ 8bit ][ 8bit ][ 8bit ]
   ^       ^       ^       ^
   |       |       |       +---- black row
   |       |       +------------ black column
   |       +-------------------- white row
   +---------------------------- white column
```

So the positions white C2 and black E7 would result in the numbers white column 2, white row 1, black column 4, black row 6; as binary number, this would be expressed as

00000010 00000001 00000100 0000110 

So the `$positions` argument would be 16810502.

You can use integer division or bit shifting and division remainder or bitwise and to get at every one value.
