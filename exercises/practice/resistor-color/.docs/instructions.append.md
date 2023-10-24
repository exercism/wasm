# Instructions append

## Reserved Memory

The buffer for the input string uses bytes 64-189 of linear memory.

## Arrays

WebAssembly does not have the concept of arrays.
For the colors test, return a comma-delimited buffer of characters in the form: `black,brown,red,orange,yellow,green,blue,violet,grey,white`

You will then have to internally build an array of structures using offsets and lengths to provide structure around this buffer.
