import { compileWat, WasmRunner } from "wasm-lib";

let wasmModule;
let currentInstance;

function isPangram(input = "") {
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
  return currentInstance.exports.isPangram(
    inputBufferOffset,
    inputLengthEncoded
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./pangram.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

describe("Pangram()", () => {
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

  test("empty sentence", () => {
    expect(isPangram("")).toBe(0);
  });

  xtest("perfect lower case", () => {
    expect(isPangram("abcdefghijklmnopqrstuvwxyz")).toBe(1);
  });

  xtest("only lower case", () => {
    expect(isPangram("the quick brown fox jumps over the lazy dog")).toBe(1);
  });

  xtest("missing the letter 'x'", () => {
    expect(
      isPangram("a quick movement of the enemy will jeopardize five gunboats")
    ).toBe(0);
  });

  xtest("missing the letter 'h'", () => {
    expect(isPangram("five boxing wizards jump quickly at it")).toBe(0);
  });

  xtest("with underscores", () => {
    expect(isPangram("the_quick_brown_fox_jumps_over_the_lazy_dog")).toBe(1);
  });

  xtest("with numbers", () => {
    expect(isPangram("the 1 quick brown fox jumps over the 2 lazy dogs")).toBe(
      1
    );
  });

  xtest("missing letters replaced by numbers", () => {
    expect(isPangram("7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog")).toBe(0);
  });

  xtest("mixed case and punctuation", () => {
    expect(isPangram('"Five quacking Zephyrs jolt my wax bed."')).toBe(1);
  });

  xtest("case insensitive", () => {
    expect(isPangram("the quick brown fox jumps over with lazy FX")).toBe(0);
  });
});
