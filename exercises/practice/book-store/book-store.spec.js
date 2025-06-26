import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./book-store.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function total(basket) {
  const inputOffset = 64;
  const inputBuffer = currentInstance.get_mem_as_i32(
    inputOffset,
    basket.length
  );

  inputBuffer.set(basket, 0);

  // Pass offset and length to WebAssembly function
  return currentInstance.exports.total(
    inputOffset,
    basket.length
  );
}

describe("total", () => {
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

  test('Only a single book', () => {
    const expected = 800;
    const actual = total([1]);
    expect(actual).toEqual(expected);
  });

  xtest('Two of the same book', () => {
    const expected = 1600;
    const actual = total([2, 2]);
    expect(actual).toEqual(expected);
  });

  xtest('Empty basket', () => {
    const expected = 0;
    const actual = total([]);
    expect(actual).toEqual(expected);
  });

  xtest('Two different books', () => {
    const expected = 1520;
    const actual = total([1, 2]);
    expect(actual).toEqual(expected);
  });

  xtest('Three different books', () => {
    const expected = 2160;
    const actual = total([1, 2, 3]);
    expect(actual).toEqual(expected);
  });

  xtest('Four different books', () => {
    const expected = 2560;
    const actual = total([1, 2, 3, 4]);
    expect(actual).toEqual(expected);
  });

  xtest('Five different books', () => {
    const expected = 3000;
    const actual = total([1, 2, 3, 4, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Two groups of four is cheaper than group of five plus group of three', () => {
    const expected = 5120;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Two groups of four is cheaper than groups of five and three', () => {
    const expected = 5120;
    const actual = total([1, 1, 2, 3, 4, 4, 5, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Group of four plus group of two is cheaper than two groups of three', () => {
    const expected = 4080;
    const actual = total([1, 1, 2, 2, 3, 4]);
    expect(actual).toEqual(expected);
  });

  xtest('Two each of first four books and one copy each of rest', () => {
    const expected = 5560;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 4, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Two copies of each book', () => {
    const expected = 6000;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 4, 5, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Three copies of first book and two each of remaining', () => {
    const expected = 6800;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 1]);
    expect(actual).toEqual(expected);
  });

  xtest('Three each of first two books and two each of remaining books', () => {
    const expected = 7520;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 1, 2]);
    expect(actual).toEqual(expected);
  });

  xtest('Four groups of four are cheaper than two groups each of five and three', () => {
    const expected = 10240;
    const actual = total([1, 1, 2, 2, 3, 3, 4, 5, 1, 1, 2, 2, 3, 3, 4, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('Check that groups of four are created properly even when there are more groups of three than groups of five', () => {
    const expected = 14560;
    const actual = total([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5]);
    expect(actual).toEqual(expected);
  });

  xtest('One group of one and four is cheaper than one group of two and three', () => {
    const expected = 3360;
    const actual = total([1, 1, 2, 3, 4]);
    expect(actual).toEqual(expected);
  });

  xtest('One group of one and two plus three groups of four is cheaper than one group of each size', () => {
    const expected = 10000;
    const actual = total([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]);
    expect(actual).toEqual(expected);
  });
});
