import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./etl.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});


const transform = (input) => {
  const serializedInput = JSON.stringify(input);

  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(serializedInput).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, serializedInput);

  const [outputOffset, outputLength] = currentInstance.exports.transform(
    inputBufferOffset, inputLengthEncoded
  );

  const outputString = currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  return JSON.parse(outputString);
}

describe('Transform legacy to new', () => {
  beforeEach(async () => {
    currentInstance = null;
    if (!wasmModule) {
      return Promise.reject();
    }
    try {
      currentInstance = await new WasmRunner(wasmModule);
      return Promise.resolve();
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
      return Promise.reject();
    }
  });

  test('single letter', () => {
    const old = { 1: ['A'] };
    const expected = { a: 1 };

    expect(transform(old)).toEqual(expected);
  });

  xtest('single score with multiple letters', () => {
    const old = { 1: ['A', 'E', 'I', 'O', 'U'] };
    const expected = {
      a: 1,
      e: 1,
      i: 1,
      o: 1,
      u: 1,
    };

    expect(transform(old)).toEqual(expected);
  });

  xtest('multiple scores with multiple letters', () => {
    const old = { 1: ['A', 'E'], 2: ['D', 'G'] };
    const expected = {
      a: 1,
      e: 1,
      d: 2,
      g: 2,
    };

    expect(transform(old)).toEqual(expected);
  });

  xtest('multiple scores with differing numbers of letters', () => {
    const old = {
      1: ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T'],
      2: ['D', 'G'],
      3: ['B', 'C', 'M', 'P'],
      4: ['F', 'H', 'V', 'W', 'Y'],
      5: ['K'],
      8: ['J', 'X'],
      10: ['Q', 'Z'],
    };
    const expected = {
      a: 1,
      b: 3,
      c: 3,
      d: 2,
      e: 1,
      f: 4,
      g: 2,
      h: 4,
      i: 1,
      j: 8,
      k: 5,
      l: 1,
      m: 3,
      n: 1,
      o: 1,
      p: 3,
      q: 10,
      r: 1,
      s: 1,
      t: 1,
      u: 1,
      v: 4,
      w: 4,
      x: 8,
      y: 4,
      z: 10,
    };

    expect(transform(old)).toEqual(expected);
  });
});