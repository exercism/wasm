import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function canChain(dominoes) {
  const inputBufferOffset = 256;
  const inputBufferCapacity = 256;

  const byteLength = dominoes.length * 2;
  if (byteLength > inputBufferCapacity) {
    throw new Error(
      `Input is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  const mem = currentInstance.get_mem_as_u8(inputBufferOffset, inputBufferCapacity);
  mem.set(dominoes.flat());

  // Pass offset and number of dominoes to WebAssembly function
  return currentInstance.exports.canChain(
    inputBufferOffset,
    dominoes.length
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./dominoes.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("canChain()", () => {
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

  test("empty input = empty output", () => {
    expect(canChain([])).toBe(1);
  });

  xtest("singleton input = singleton output", () => {
    expect(canChain([[1, 1]])).toBe(1);
  });

  xtest("singleton that can't be chained", () => {
    expect(canChain([[1, 2]])).toBe(0);
  });

  xtest("three elements", () => {
    expect(
      canChain([
        [1, 2],
        [3, 1],
        [2, 3],
      ])
    ).toBe(1);
  });

  xtest("can reverse dominoes", () => {
    expect(
      canChain([
        [1, 2],
        [1, 3],
        [2, 3],
      ])
    ).toBe(1);
  });

  xtest("can't be chained", () => {
    expect(
      canChain([
        [1, 2],
        [4, 1],
        [2, 3],
      ])
    ).toBe(0);
  });

  xtest("disconnected - simple", () => {
    expect(
      canChain([
        [1, 1],
        [2, 2],
      ])
    ).toBe(0);
  });

  xtest("disconnected - double loop", () => {
    expect(
      canChain([
        [1, 2],
        [2, 1],
        [3, 4],
        [4, 3],
      ])
    ).toBe(0);
  });

  xtest("disconnected - single isolated", () => {
    expect(
      canChain([
        [1, 2],
        [2, 3],
        [3, 1],
        [4, 4],
      ])
    ).toBe(0);
  });

  xtest("need backtrack", () => {
    expect(
      canChain([
        [1, 2],
        [2, 3],
        [3, 1],
        [2, 4],
        [2, 4],
      ])
    ).toBe(1);
  });

  xtest("separate loops", () => {
    expect(
      canChain([
        [1, 2],
        [2, 3],
        [3, 1],
        [1, 1],
        [2, 2],
        [3, 3],
      ])
    ).toBe(1);
  });

  xtest("nine elements", () => {
    expect(
      canChain([
        [1, 2],
        [5, 3],
        [3, 1],
        [1, 2],
        [2, 4],
        [1, 6],
        [2, 3],
        [3, 4],
        [5, 6],
      ])
    ).toBe(1);
  });

  xtest("separate three-domino loops", () => {
    expect(
      canChain([
        [1, 2],
        [2, 3],
        [3, 1],
        [4, 5],
        [5, 6],
        [6, 4],
      ])
    ).toBe(0);
  });
});
