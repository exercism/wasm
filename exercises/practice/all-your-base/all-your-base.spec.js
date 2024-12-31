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

const testCases = [
    { description: "single bit one to decimal", digits: [1], inputBase: 2, outputBase: 10, expected: [1] },
    { description: "binary to single decimal", digits: [1, 0, 1], inputBase: 2, outputBase: 10, expected: [5] },
    { description: "single decimal to binary", digits: [5], inputBase: 10, outputBase: 2, expected: [1, 0, 1] },
    { description: "binary to multiple decimal", digits: [1, 0, 1, 0, 1, 0], inputBase: 2, outputBase: 10, expected: [4, 2] },
    { description: "decimal to binary", digits: [4, 2], inputBase: 10, outputBase: 2, expected: [1, 0, 1, 0, 1, 0] },
    { description: "trinary to hexadecimal", digits: [1, 1, 2, 0], inputBase: 3, outputBase: 16, expected: [2, 10] },
    { description: "hexadecimal to trinary", digits: [2, 10], inputBase: 16, outputBase: 3, expected: [1, 1, 2, 0] },
    { description: "15-bit integer", digits: [3, 46, 60], inputBase: 97, outputBase: 73, expected: [6, 10, 45] },
    { description: "empty list", digits: [], inputBase: 2, outputBase: 10, expected: [], expectedErrorCode: -1 },
    { description: "single zero", digits: [0], inputBase: 10, outputBase: 2, expected: [0] },
    { description: "multiple zeros", digits: [0, 0, 0], inputBase: 10, outputBase: 2, expected: [], expectedErrorCode: -1 },
    { description: "leading zeros", digits: [0, 6, 0], inputBase: 7, outputBase: 10, expected: [], expectedErrorCode: -1 },
    { description: "negative digit", digits: [1, -1, 1, 0, 1, 0], inputBase: 2, outputBase: 10, expected: [], expectedErrorCode: -1 },
    { description: "invalid positive digit", digits: [1, 2, 1, 0, 1, 0], inputBase: 2, outputBase: 10, expected: [], expectedErrorCode: -1 },
    { description: "first base is one", digits: [], inputBase: 1, outputBase: 10, expected: [], expectedErrorCode: -2 },
    { description: "second base is one", digits: [1, 0, 1, 0, 1, 0], inputBase: 2, outputBase: 1, expected: [], expectedErrorCode: -3 },
    { description: "first base is zero", digits: [], inputBase: 0, outputBase: 10, expected: [], expectedErrorCode: -2 },
    { description: "second base is zero", digits: [7], inputBase: 10, outputBase: 0, expected: [], expectedErrorCode: -3 },
    { description: "first base is negative", digits: [1], inputBase: -2, outputBase: 10, expected: [], expectedErrorCode: -2 },
    { description: "second base is negative", digits: [1], inputBase: 2, outputBase: -7, expected: [], expectedErrorCode: -3 },
    { description: "both bases are negative", digits: [1], inputBase: -2, outputBase: -7, expected: [], expectedErrorCode: -2 }
  ];

  testCases.forEach(({ description, digits, inputBase, outputBase, expected, expectedErrorCode }) => {
    test(description, () => {
      let [results, rc] = convert(digits, inputBase, outputBase);
      expect(rc).toEqual(expectedErrorCode || 0);
      expect(results).toEqual(expected);
    });
  });
});
