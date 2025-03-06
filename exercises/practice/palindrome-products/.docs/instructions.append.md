## Return values

The functions are supposed to return the product and the offset and length of the factors array. The factors are just written as pairs of i32 into memory:


```
Return value:
[u32 $product] [u32 $factorsOffset] [u32 $factorsLength]

Memory at $factorsOffset
[u32 firstFactor] [u32 firstCofactor] [u32 secondFactor] [u32 secondCofactor] ...
```

For the largest one-digit palindrome product, it would look like this:

```
Return value
0009 0000 0004

Memory at offset 0
0001 0009 0003 0003
```
