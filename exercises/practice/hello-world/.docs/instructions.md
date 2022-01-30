# Instructions

The classical introductory exercise. Just say "Hello, World!".

Unfortunately, this is quite complex in WebAssembly!

WebAssembly is an execution environment that typically runs as a sandbox within a language runtime, called the "embedding environment." In the browser, this "embedding environment" is the JavaScript runtime. However, WebAssembly also runs on the server as well. For example, Envoy and Istio are two server-side components that allow developers to run untrusted third-party extensions written in WebAssembly. In these programs, the "embedding environment" is C++ and Go respectively. This use is attractive because WebAssembly is a security domain. Code that runs in WebAssembly cannot breakout and execute arbitrary host code. Code within WebAssembly is largely opaque to the surrounding "embedding environment". In order to communicate between the WebAssembly sandbox and the surrounding embedding environment, we use imports and exports. In some ways, this division is similar to modules and export/import semantics around modules in high-level languages.

A major difference between WebAssembly sandboxes and language-specific modules is that WebAssembly is a low-level abstraction, and it does not understand the language-specific features of the runtime that surrounds it. In our case, we are running WebAssembly in Node.js. However, the \*.wat files we are writing do not understand how JavaScript works, and they do not understand the conventions for building and passing JavaScript strings in a form that our JavaScript test runner can understand. In order to bridge our "Hello, World!" from WebAssembly to JavaScript, we need to import and use special JavaScript "glue code" that understands how to convert bytes from WebAssembly linear memory into JavaScript strings. Such glue code is common and specific to the "embedding environment" that WebAssembly is running in.

In our case, the glue code is `buildHostString`, which takes the base offset and length of a string in WebAssembly linear memory and builds a JavaScript string.

```wasm
(import "env" "buildHostString" (func $build_host_string (param i32) (param i32)))
```

WebAssembly linear memory can be thought of as an address space similar to operating system processes. It is a byte-addressable vector of raw uninitialized data that WebAssembly instructions can operation upon. It is size by WebAssembly pages, which are 64KiB in size. This means that one WebAssembly page is the same memory capacity as a Commodore 64 from the 1980s. Though indices into address spaces are typically called addresses, the WebAssembly specification prefers the term `offset`. In the current specification, a WebAssembly offset is a 32-bit unsigned integer, which means that a WebAssembly linear memory can dynamically grow up to 4gb.

Many WebAssembly modules declare their own memories like such:

```wasm
(memory 1)
```

However, in our example, we instead do the following:

```wasm
(import "env" "linearMemory" (memory 1))
```

The reason for this is that we want to pass responsibility for allocating our linear memory to the JavaScript runtime. This ensures that the JavaScript runtime has a reference that it can use to access our linear memory directly. This is used by our "glue code" function `buildHostString` to read the raw UTF-8 characters written to our linear memory.

## Supplemental Information for those new to Systems Programming

### Character Encoding and String Representation

In high-level languages like JavaScript, a string is a concrete type. This means that we can save a string a variable and return it from a function.

```js
function hello() {
  let greeting = "Goodbye, Mars!";
  return greeting;
}
```

It also has handy attributes and methods that we can use to do things like check the length of a string:

```js
let greeting = "Goodbye, Mars!";
console.log(greeting.length); // Outputs "14"
```

Compared to such languages, WebAssembly is quite low-level. For example, according to the WebAssembly specification, there are only four base types:

- i32, a 32-bit integral type that can hold a whole number
- i64, a 64-bit integral type that can hold a whole number
- f32, a 32-bit floating point type that can hold numbers with decimals
- f64, a 64-bit floating point type that can hold numbers with decimals

Additionally, there are various instructions to interact with the inter types as smaller widths (8-bit, 16-bit, etc.) and as either signed numbers (can hold a positive or negative number) or unsigned numbers (can only hold 0 or a positive number).

In order to work in strings, WebAssembly thus needs to find a way to express text as numbers. The term for this is character encoding (https://en.wikipedia.org/wiki/Character_encoding).

Text is modeled as a sequence of characters, and each character is encoded as a whole number called a "character code" or "code point." A simple example of this is ASCII, the American Standard Code for Information Interchange(https://en.wikipedia.org/wiki/ASCII). Under this standard, a zero '0' is 48, an uppercase 'A' is 65, and a lowercase 'a' is 97.

ASCII could only express 127 possible characters, which worked fine for English, but many languages have different alphabets than English and thus extended ASCII to assign their unique letters the numbers 128-255. However, this caused these numbers to have different representations depending on the country one lived in. If the encoding was transmitted between a computer set to German and a computer set to Russian, the wrong characters would be drawn. This problem became even more pronounced as computing spread to countries like Japan and China, which have large numbers of characters in their written language.

The Unicode Standard was created to help create a universal character encoding standard that can express all written human languages. There are a several encoding variants of the Unicode standard. JavaScript uses UTF-16, a encoding that is 16 bits wide. Many low-level languages use UTF-8, an 8 bit encoding that provides easier compatibility with ASCII.

Even with these advances, Unicode does not fully solve the problem of representing strings. In addition to knowing how to encode and decode characters, a language needs a way to identify the start and end of a given sequence. This differs between languages, making string representations language specific.

### Linear Memory

According to the WebAssembly specification, a WebAssembly program has access to a `linear memory`, which is defined as "a vector of raw uninterpreted bytes," sized according to a certain number of 64 KiB pages.

The following command imports a linear memory of 65,536 raw uninterpreted bytes.

```wasm
(import "env" "linearMemory" (memory 1))
```

Our WebAssembly module can use various WebAssembly instructions to read and write to these bytes of memory.

It is as if we had an array of 65,536 elements, and each element could hold a whole number between 0 and 255. This is the same amount of memory as a famous 1980s computer called the Commodore 64. On a physical computer, the "index" into this vector of raw uninterpreted bytes is called an "address." In the WebAssembly specification, this is instead called an "offset."

There are numerous WebAssembly instructions for reading and writing data into memory. However, initializing static strings can be accomplished using an active data segment.

The following example writes "Yo, Mars!" as a sequence of UTF-8 characters starting at offset 200

```wasm
(data (i32.const 200) "Yo, Mars!")
```

This results in the following bytes located at the following offsets in our linear memory

| Offset | Character | Decimal Encoding |
| ------ | --------- | ---------------- |
| 200    | 'Y'       | 89               |
| 201    | 'o'       | 111              |
| 202    | ','       | 44               |
| 203    | ' '       | 32               |
| 204    | 'M'       | 77               |
| 215    | 'a'       | 97               |
| 216    | 'r'       | 72               |
| 217    | 's'       | 115              |
| 218    | '!'       | 33               |
