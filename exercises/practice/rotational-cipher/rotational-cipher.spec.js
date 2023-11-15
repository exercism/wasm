import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./rotational-cipher.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function rotate(text, shiftKey) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(text).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, text);

  const [outputOffset, outputLength] = currentInstance.exports.rotate(
    inputBufferOffset,
    text.length,
    shiftKey
  );
  expect(outputLength).toEqual(text.length);

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Rotational Cipher", () => {
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

  test("rotate a by 0, same output as input", () => {
    expect(rotate("a", 0)).toEqual("a");
  });

  xtest("rotate a by 1", () => {
    expect(rotate("a", 1)).toEqual("b");
  });

  xtest("rotate a by 26, same output as input", () => {
    expect(rotate("a", 26)).toEqual("a");
  });

  xtest("rotate m by 13", () => {
    expect(rotate("m", 13)).toEqual("z");
  });

  xtest("rotate n by 13 with wrap around alphabet", () => {
    expect(rotate("n", 13)).toEqual("a");
  });

  xtest("rotate capital letters", () => {
    expect(rotate("OMG", 5)).toEqual("TRL");
  });

  xtest("rotate spaces", () => {
    expect(rotate("O M G", 5)).toEqual("T R L");
  });

  xtest("rotate numbers", () => {
    expect(rotate("Testing 1 2 3 testing", 4)).toEqual("Xiwxmrk 1 2 3 xiwxmrk");
  });

  xtest("rotate punctuation", () => {
    expect(rotate("Let's eat, Grandma!", 21)).toEqual("Gzo'n zvo, Bmviyhv!");
  });

  xtest("rotate all letters", () => {
    expect(rotate("The quick brown fox jumps over the lazy dog.", 13)).toEqual(
      "Gur dhvpx oebja sbk whzcf bire gur ynml qbt."
    );
  });
});
