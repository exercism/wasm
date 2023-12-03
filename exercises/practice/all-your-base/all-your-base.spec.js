import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./all-your-base.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function convert(digits = [], inputBase, outputBase) {
  const inputOffset = 64;
  const inputBuffer = currentInstance.get_mem_as_i32(
    inputOffset,
    digits.length
  );

  inputBuffer.set(digits, 0);

  // Pass offset and length to WebAssembly function
  let [outputOffset, outputLength, rc] = currentInstance.exports.convert(
    inputOffset,
    digits.length,
    inputBase,
    outputBase
  );

  if (rc !== 0) {
    return [[], rc];
  }

  const outputBuffer = currentInstance.get_mem_as_i32(
    outputOffset,
    outputLength
  );

  return [[...outputBuffer], rc];
}

describe("Converter", () => {
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

  test("single bit one to decimal", () => {
    let [results, rc] = convert([1], 2, 10);
    expect(rc).toEqual(0);
    expect(results).toEqual([1]);
  });

  xtest("binary to single decimal", () => {
    let [results, rc] = convert([1, 0, 1], 2, 10);
    expect(rc).toEqual(0);
    expect(results).toEqual([5]);
  });

  xtest("single decimal to binary", () => {
    let [results, rc] = convert([5], 10, 2);
    expect(rc).toEqual(0);
    expect(results).toEqual([1, 0, 1]);
  });

  xtest("binary to multiple decimal", () => {
    let [results, rc] = convert([1, 0, 1, 0, 1, 0], 2, 10);
    expect(rc).toEqual(0);
    expect(results).toEqual([4, 2]);
  });

  xtest("decimal to binary", () => {
    let [results, rc] = convert([4, 2], 10, 2);
    expect(rc).toEqual(0);
    expect(results).toEqual([1, 0, 1, 0, 1, 0]);
  });

  xtest("trinary to hexadecimal", () => {
    let [results, rc] = convert([1, 1, 2, 0], 3, 16);
    expect(rc).toEqual(0);
    expect(results).toEqual([2, 10]);
  });

  xtest("hexadecimal to trinary", () => {
    let [results, rc] = convert([2, 10], 16, 3);
    expect(rc).toEqual(0);
    expect(results).toEqual([1, 1, 2, 0]);
  });

  xtest("15-bit integer", () => {
    let [results, rc] = convert([3, 46, 60], 97, 73);
    expect(rc).toEqual(0);
    expect(results).toEqual([6, 10, 45]);
  });

  xtest("empty list", () => {
    let [_, rc] = convert([], 2, 10);
    expect(rc).toEqual(-1);
  });

  xtest("single zero", () => {
    let [results, rc] = convert([0], 10, 2);
    expect(rc).toEqual(0);
    expect(results).toEqual([0]);
  });

  xtest("multiple zeros", () => {
    let [_, rc] = convert([0, 0, 0], 10, 2);
    expect(rc).toEqual(-1);
  });

  xtest("leading zeros", () => {
    let [_, rc] = convert([0, 6, 0], 7, 10);
    expect(rc).toEqual(-1);
  });

  xtest("negative digit", () => {
    let [_, rc] = convert([1, -1, 1, 0, 1, 0], 2, 10);
    expect(rc).toEqual(-1);
  });

  xtest("invalid positive digit", () => {
    let [_, rc] = convert([1, 2, 1, 0, 1, 0], 2, 10);
    expect(rc).toEqual(-1);
  });

  xtest("first base is one", () => {
    let [_, rc] = convert([], 1, 10);
    expect(rc).toEqual(-2);
  });

  xtest("second base is one", () => {
    let [_, rc] = convert([1, 0, 1, 0, 1, 0], 2, 1);
    expect(rc).toEqual(-3);
  });

  xtest("first base is zero", () => {
    let [_, rc] = convert([], 0, 10);
    expect(rc).toEqual(-2);
  });

  xtest("second base is zero", () => {
    let [_, rc] = convert([7], 10, 0);
    expect(rc).toEqual(-3);
  });

  xtest("first base is negative", () => {
    let [_, rc] = convert([1], -2, 10);
    expect(rc).toEqual(-2);
  });

  xtest("second base is negative", () => {
    let [_, rc] = convert([1], 2, -7);
    expect(rc).toEqual(-3);
  });

  xtest("both bases are negative", () => {
    let [_, rc] = convert([1], -2, -7);
    expect(rc).toEqual(-2);
  });
});
