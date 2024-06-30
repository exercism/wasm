# Instructions append

The items are passed through linear memory, with the first item at offset 0.
Each item is represented as a pair of 32-bit integers.
The first number in the pair is the weight and the second is the value.

For example, consider a list of two items, where the first has `weight=1, value=2` and the second `weight=5, value=8`.
The list would thus look like this in memory:

```
| 00 | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 |
| - item 1 weight - | -- item 1 value - | - item 2 weight - | -- item 2 value - |
|0x01,0x00,0x00,0x00|0x02,0x00,0x00,0x00|0x05,0x00,0x00,0x00|0x08,0x00,0x00,0x00|
```

If you so choose, you may overwrite the addresses of linear memory used for the input.