import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function largestProduct(input = "", span) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  // Pass offset and length to WebAssembly function
  return currentInstance.exports.largestProduct(
    inputBufferOffset,
    inputLengthEncoded,
    span
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./largest-series-product.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("largestProduct()", () => {
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

  test("finds the largest product if span equals length", () => {
    const expected = 18;
    const actual = largestProduct("29", 2);
    expect(actual).toEqual(expected);
  });

  xtest("can find the largest product of 2 with numbers in order", () => {
    const expected = 72;
    const actual = largestProduct("0123456789", 2);
    expect(actual).toEqual(expected);
  });

  xtest("can find the largest product of 2", () => {
    const expected = 48;
    const actual = largestProduct("576802143", 2);
    expect(actual).toEqual(expected);
  });

  xtest("can find the largest product of 3 with numbers in order", () => {
    const expected = 504;
    const actual = largestProduct("0123456789", 3);
    expect(actual).toEqual(expected);
  });

  xtest("can find the largest product of 3", () => {
    const expected = 270;
    const actual = largestProduct("1027839564", 3);
    expect(actual).toEqual(expected);
  });

  xtest("can find the largest product of 5 with numbers in order", () => {
    const expected = 15120;
    const actual = largestProduct("0123456789", 5);
    expect(actual).toEqual(expected);
  });

  xtest("can get the largest product of a big number", () => {
    const expected = 23520;
    const actual = largestProduct("73167176531330624919225119674426574742355349194934", 6);
    expect(actual).toEqual(expected);
  });

  xtest("reports zero if the only digits are zero", () => {
    const expected = 0;
    const actual = largestProduct("0000", 2);
    expect(actual).toEqual(expected);
  });

  xtest("reports zero if all spans include zero", () => {
    const expected = 0;
    const actual = largestProduct("99099", 3);
    expect(actual).toEqual(expected);
  });

  xtest("rejects span longer than string length", () => {
    const expected = -1;
    const actual = largestProduct("123", 4);
    expect(actual).toEqual(expected);
  });

  xtest("reports 1 for empty string and empty product (0 span)", () => {
    const expected = 1;
    const actual = largestProduct("", 0);
    expect(actual).toEqual(expected);
  });

  xtest("reports 1 for nonempty string and empty product (0 span)", () => {
    const expected = 1;
    const actual = largestProduct("123", 0);
    expect(actual).toEqual(expected);
  });

  xtest("rejects empty string and nonzero span", () => {
    const expected = -1;
    const actual = largestProduct("", 1);
    expect(actual).toEqual(expected);
  });

  xtest("rejects invalid character in digits", () => {
    const expected = -1;
    const actual = largestProduct("1234a5", 2);
    expect(actual).toEqual(expected);
  });

  xtest("rejects negative span", () => {
    const expected = -1;
    const actual = largestProduct("12345", -1);
    expect(actual).toEqual(expected);
  });
});
