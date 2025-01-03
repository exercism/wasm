import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./scrabble-score.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function score(word = "") {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 128;

  const inputLengthEncoded = new TextEncoder().encode(word).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, word);

  return currentInstance.exports.score(
    inputBufferOffset,
    inputLengthEncoded
  );
}

describe("ScrabbleScore", () => {
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

  test("lowercase letter", () => {
    expect(score("a")).toBe(1);
  });

  xtest("uppercase letter", () => {
    expect(score("A")).toBe(1);
  });

  xtest("valuable letter", () => {
    expect(score("f")).toBe(4);
  });

  xtest("short word", () => {
    expect(score("at")).toBe(2);
  });

  xtest("short, valuable word", () => {
    expect(score("zoo")).toBe(12);
  });

  xtest("medium word", () => {
    expect(score("street")).toBe(6);
  });

  xtest("medium, valuable word", () => {
    expect(score("quirky")).toBe(22);
  });

  xtest("long, mixed-case word", () => {
    expect(score("OxyphenButazone")).toBe(41);
  });

  xtest("english-like word", () => {
    expect(score("pinata")).toBe(8);
  });

  xtest("empty input", () => {
    expect(score("")).toBe(0);
  });

  xtest("entire alphabet available", () => {
    expect(score("abcdefghijklmnopqrstuvwxyz")).toBe(87);
  });
});
