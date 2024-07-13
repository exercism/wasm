import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function valid(input = "") {
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
  return currentInstance.exports.valid(
    inputBufferOffset,
    inputLengthEncoded
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./luhn.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("valid()", () => {
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

  test("single digit strings can not be valid", () => {
    expect(valid("1")).toBe(0);
  });

  xtest("a single zero is invalid", () => {
    expect(valid("0")).toBe(0);
  });

  xtest("a simple valid SIN that remains valid if reversed", () => {
    expect(valid("059")).toBe(1);
  });

  xtest("a simple valid SIN that becomes invalid if reversed", () => {
    expect(valid("59")).toBe(1);
  });

  xtest("a valid Canadian SIN", () => {
    expect(valid("055 444 285")).toBe(1);
  });

  xtest("invalid Canadian SIN", () => {
    expect(valid("055 444 286")).toBe(0);
  });

  xtest("invalid credit card", () => {
    expect(valid("8273 1232 7352 0569")).toBe(0);
  });

  xtest("invalid long number with an even remainder", () => {
    expect(valid("1 2345 6789 1234 5678 9012")).toBe(0);
  });

  xtest("invalid long number with a remainder divisible by 5", () => {
    expect(valid("1 2345 6789 1234 5678 9013")).toBe(0);
  });

  xtest("valid number with an even number of digits", () => {
    expect(valid("095 245 88")).toBe(1);
  });

  xtest("valid number with an odd number of spaces", () => {
    expect(valid("234 567 891 234")).toBe(1);
  });

  xtest("valid strings with a non-digit added at the end become invalid", () => {
    expect(valid("059a")).toBe(0);
  });

  xtest("valid strings with punctuation included become invalid", () => {
    expect(valid("055-444-285")).toBe(0);
  });

  xtest("valid strings with symbols included become invalid", () => {
    expect(valid("055# 444$ 285")).toBe(0);
  });

  xtest("single zero with space is invalid", () => {
    expect(valid(" 0")).toBe(0);
  });

  xtest("more than a single zero is valid", () => {
    expect(valid("0000 0")).toBe(1);
  });

  xtest("input digit 9 is correctly converted to output digit 9", () => {
    expect(valid("091")).toBe(1);
  });

  xtest("very long input is valid", () => {
    expect(valid("9999999999 9999999999 9999999999 9999999999")).toBe(1);
  });

  xtest("valid luhn with an odd number of digits and non zero first digit", () => {
    expect(valid("109")).toBe(1);
  });

  xtest("using ascii value for non-doubled non-digit isn't allowed", () => {
    expect(valid("055b 444 285")).toBe(0);
  });

  xtest("using ascii value for doubled non-digit isn't allowed", () => {
    expect(valid(":9")).toBe(0);
  });

  xtest("non-numeric, non-space char in the middle with a sum that's divisible by 10 isn't allowed", () => {
    expect(valid("59%59")).toBe(0);
  });
});
