# Instructions append

## Reserved Memory

The buffer for the input string uses bytes 64-191 of linear memory.


## Output format

The series of numbers are expected as one continuous array of u8 numbers; it will be split by length in deserialization:

```js
slice("123456", 3) => UInt8Array[1, 2, 3,   2, 3, 4,   3, 4, 5,   4, 5, 6]
// will be split into          [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]
```
