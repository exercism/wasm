import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./crypto-square.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function ciphertext(input) {
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
  const [outputOffset, outputLength] = currentInstance.exports.ciphertext(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Crypto Square", () => {
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

  test("empty plaintext results in an empty ciphertext", () => {
    const expected = "";
    const actual = ciphertext("");
    expect(actual).toEqual(expected);
  });

  xtest("normalization results in empty plaintext", () => {
    const expected = "";
    const actual = ciphertext("... --- ...");
    expect(actual).toEqual(expected);
  });

  xtest("Lowercase", () => {
    const expected = "a";
    const actual = ciphertext("A");
    expect(actual).toEqual(expected);
  });

  xtest("Remove spaces", () => {
    const expected = "b";
    const actual = ciphertext("  b ");
    expect(actual).toEqual(expected);
  });

  xtest("Remove punctuation", () => {
    const expected = "1";
    const actual = ciphertext("@1,%!");
    expect(actual).toEqual(expected);
  });

  xtest("9 character plaintext results in 3 chunks of 3 characters", () => {
    const expected = "tsf hiu isn";
    const actual = ciphertext("This is fun!");
    expect(actual).toEqual(expected);
  });

  xtest("8 character plaintext results in 3 chunks, the last one with a trailing space", () => {
    const expected = "clu hlt io ";
    const actual = ciphertext("Chill out.");
    expect(actual).toEqual(expected);
  });

  xtest("54 character plaintext results in 8 chunks, the last two with trailing spaces", () => {
    const expected = "imtgdvs fearwer mayoogo anouuio ntnnlvt wttddes aohghn  sseoau ";
    const actual = ciphertext("If man was meant to stay on the ground, god would have given us roots.");
    expect(actual).toEqual(expected);
  });
});
