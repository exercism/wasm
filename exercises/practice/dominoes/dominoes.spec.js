import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function canChain(input = "") {
  const inputBufferOffset = 256;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  // Pass offset and length to WebAssembly function
  return currentInstance.exports.canChain(
    inputBufferOffset,
    inputLengthEncoded
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
    expect(canChain("")).toBe(1);
  });

  xtest("singleton input = singleton output", () => {
    expect(canChain("\x11")).toBe(1);
  });

  xtest("singleton that can't be chained", () => {
    expect(canChain("\x12")).toBe(0);
  });

  xtest("three elements", () => {
    expect(canChain("\x12\x31\x23")).toBe(1);
  });

  xtest("can reverse dominoes", () => {
    expect(canChain("\x12\x13\x23")).toBe(1);
  });

  xtest("can't be chained", () => {
    expect(canChain("\x12\x41\x23")).toBe(0);
  });

  xtest("disconnected - simple", () => {
    expect(canChain("\x11\x22")).toBe(0);
  });

  xtest("disconnected - double loop", () => {
    expect(canChain("\x12\x21\x34\x43")).toBe(0);
  });

  xtest("disconnected - single isolated", () => {
    expect(canChain("\x12\x23\x31\x44")).toBe(0);
  });

  xtest("need backtrack", () => {
    expect(canChain("\x12\x23\x31\x24\x24")).toBe(1);
  });

  xtest("separate loops", () => {
    expect(canChain("\x12\x23\x31\x11\x22\x33")).toBe(1);
  });

  xtest("nine elements", () => {
    expect(canChain("\x12\x53\x31\x12\x24\x16\x23\x34\x56")).toBe(1);
  });

  xtest("separate three-domino loops", () => {
    expect(canChain("\x12\x23\x31\x45\x56\x64")).toBe(0);
  });

});
