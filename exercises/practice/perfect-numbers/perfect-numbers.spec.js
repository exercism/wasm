import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function classify(number) {
  return currentInstance.exports.classify(
    number
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./perfect-numbers.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("classify()", () => {
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

  test("Smallest perfect number is classified correctly", () => {
    expect(classify(6)).toBe(2);
  });

  xtest("Medium perfect number is classified correctly", () => {
    expect(classify(28)).toBe(2);
  });

  xtest("Large perfect number is classified correctly", () => {
    expect(classify(33550336)).toBe(2);
  });

  xtest("Smallest abundant number is classified correctly", () => {
    expect(classify(12)).toBe(3);
  });

  xtest("Medium abundant number is classified correctly", () => {
    expect(classify(30)).toBe(3);
  });

  xtest("Large abundant number is classified correctly", () => {
    expect(classify(33550335)).toBe(3);
  });

  xtest("Smallest prime deficient number is classified correctly", () => {
    expect(classify(2)).toBe(1);
  });

  xtest("Smallest non-prime deficient number is classified correctly", () => {
    expect(classify(4)).toBe(1);
  });

  xtest("Medium deficient number is classified correctly", () => {
    expect(classify(32)).toBe(1);
  });

  xtest("Large deficient number is classified correctly", () => {
    expect(classify(33550337)).toBe(1);
  });

  xtest("Edge case (no factors other than itself) is classified correctly", () => {
    expect(classify(1)).toBe(1);
  });

  xtest("Zero is rejected (as it is not a positive integer)", () => {
    expect(classify(0)).toBe(0);
  });

  xtest("Negative integer is rejected (as it is not a positive integer)", () => {
    expect(classify(-1)).toBe(0);
  });
});
