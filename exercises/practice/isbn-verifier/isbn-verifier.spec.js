import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function isValid(input = "") {
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
  return currentInstance.exports.isValid(
    inputBufferOffset,
    inputLengthEncoded
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./isbn-verifier.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("isValid()", () => {
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

  test("valid isbn", () => {
    expect(isValid("3-598-21508-8")).toBe(1);
  });

  xtest("invalid isbn check digit", () => {
    expect(isValid("3-598-21508-9")).toBe(0);
  });

  xtest("valid isbn with a check digit of 10", () => {
    expect(isValid("3-598-21507-X")).toBe(1);
  });

  xtest("check digit is a character other than X", () => {
    expect(isValid("3-598-21507-A")).toBe(0);
  });

  xtest("invalid check digit in isbn is not treated as zero", () => {
    expect(isValid("4-598-21507-B")).toBe(0);
  });

  xtest("invalid character in isbn is not treated as zero", () => {
    expect(isValid("3-598-P1581-X")).toBe(0);
  });

  xtest("X is only valid as a check digit", () => {
    expect(isValid("3-598-2X507-9")).toBe(0);
  });

  xtest("valid isbn without separating dashes", () => {
    expect(isValid("3598215088")).toBe(1);
  });

  xtest("isbn without separating dashes and X as check digit", () => {
    expect(isValid("359821507X")).toBe(1);
  });

  xtest("isbn without check digit and dashes", () => {
    expect(isValid("359821507")).toBe(0);
  });

  xtest("too long isbn and no dashes", () => {
    expect(isValid("3598215078X")).toBe(0);
  });

  xtest("too short isbn", () => {
    expect(isValid("00")).toBe(0);
  });

  xtest("isbn without check digit", () => {
    expect(isValid("3-598-21507")).toBe(0);
  });

  xtest("check digit of X should not be used for 0", () => {
    expect(isValid("3-598-21515-X")).toBe(0);
  });

  xtest("empty isbn", () => {
    expect(isValid("")).toBe(0);
  });

  xtest("input is 9 characters", () => {
    expect(isValid("134456729")).toBe(0);
  });

  xtest("invalid characters are not ignored after checking length", () => {
    expect(isValid("3132P34035")).toBe(0);
  });

  xtest("invalid characters are not ignored before checking length", () => {
    expect(isValid("3598P215088")).toBe(0);
  });

  xtest("input is too long but contains a valid isbn", () => {
    expect(isValid("98245726788")).toBe(0);
  });
});
