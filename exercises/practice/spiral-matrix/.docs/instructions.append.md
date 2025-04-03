## Output format

The output is expected as a flat array of u16 numbers; it will be deserialized into the required square array of arrays:

```js
// output
[1,2,3,8,9,4,7,6,5]
// =>
// [[1, 2, 3],
//  [8, 9, 4],
//  [7, 6, 5]]
```
