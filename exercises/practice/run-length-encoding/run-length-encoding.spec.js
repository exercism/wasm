import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./run-length-encoding.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function invoke(funcName, input) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  const [ outputOffset, outputLength ] = currentInstance.exports[funcName](
    inputBufferOffset,
    input.length
  );

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
 }

describe("RunLengthEncoding", () => {
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

  test("encode empty string", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "";
    const actual = invoke("encode", "");
    expect(actual).toEqual(expected);
  });

  xtest("encode single characters only are encoded without count", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "XYZ";
    const actual = invoke("encode", "XYZ");
    expect(actual).toEqual(expected);
  });

  xtest("encode string with no single characters", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "2A3B4C";
    const actual = invoke("encode", "AABBBCCCC");
    expect(actual).toEqual(expected);
  });

  xtest("encode single characters mixed with repeated characters", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "12WB12W3B24WB";
    const actual = invoke("encode", "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");
    expect(actual).toEqual(expected);
  });

  xtest("encode multiple whitespace mixed in string", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "2 hs2q q2w2 ";
    const actual = invoke("encode", "  hsqq qww  ");
    expect(actual).toEqual(expected);
  });

  xtest("encode lowercase characters", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "2a3b4c";
    const actual = invoke("encode", "aabbbcccc");
    expect(actual).toEqual(expected);
  });

  xtest("decode empty string", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "";
    const actual = invoke("decode", "");
    expect(actual).toEqual(expected);
  });

  xtest("decode single characters only", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "XYZ";
    const actual = invoke("decode", "XYZ");
    expect(actual).toEqual(expected);
  });

  xtest("decode string with no single characters", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "AABBBCCCC";
    const actual = invoke("decode", "2A3B4C");
    expect(actual).toEqual(expected);
  });

  xtest("decode single characters with repeated characters", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB";
    const actual = invoke("decode", "12WB12W3B24WB");
    expect(actual).toEqual(expected);
  });

  xtest("decode multiple whitespace mixed in string", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "  hsqq qww  ";
    const actual = invoke("decode", "2 hs2q q2w2 ");
    expect(actual).toEqual(expected);
  });

  xtest("decode lowercase string", () => {
    expect(currentInstance).toBeTruthy();
    const expected = "aabbbcccc";
    const actual = invoke("decode", "2a3b4c");
    expect(actual).toEqual(expected);
  });

  xtest("encode followed by decode gives original string", () => {
    expect(currentInstance).toBeTruthy();
    const input = "zzz ZZ  zZ";
    const output = invoke("decode", invoke("encode", input));
    expect(output).toEqual(input);
  });
});
