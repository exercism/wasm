import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function value(first, second) {
  const firstBufferOffset = 1024;
  const firstBufferCapacity = 1024;

  const firstLengthEncoded = new TextEncoder().encode(first).length;
  if (firstLengthEncoded > firstBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${firstBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(firstBufferOffset, firstLengthEncoded, first);

  const secondBufferOffset = 2048;
  const secondBufferCapacity = 1024;

  const secondLengthEncoded = new TextEncoder().encode(second).length;
  if (secondLengthEncoded > secondBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${secondBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(
    secondBufferOffset,
    secondLengthEncoded,
    second
  );

  return currentInstance.exports.value(
    firstBufferOffset,
    firstLengthEncoded,
    secondBufferOffset,
    secondLengthEncoded
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./resistor-color-duo.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("Resistor Color Duo", () => {
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

  test("Brown and black", () => {
    const expected = 10;
    const actual = value("brown", "black");
    expect(actual).toEqual(expected);
  });

  xtest("Blue and grey", () => {
    const expected = 68;
    const actual = value("blue", "grey");
    expect(actual).toEqual(expected);
  });

  xtest("Yellow and violet", () => {
    const expected = 47;
    const actual = value("yellow", "violet");
    expect(actual).toEqual(expected);
  });

  xtest("White and red", () => {
    const expected = 92;
    const actual = value("white", "red");
    expect(actual).toEqual(expected);
  });

  xtest("Orange and orange", () => {
    const expected = 33;
    const actual = value("orange", "orange");
    expect(actual).toEqual(expected);
  });

  xtest("Ignore additional colors", () => {
    const expected = 51;
    const actual = value("green", "brown");
    expect(actual).toEqual(expected);
  });

  xtest("Black and brown, one-digit", () => {
    const expected = 1;
    const actual = value("black", "brown");
    expect(actual).toEqual(expected);
  });
});
