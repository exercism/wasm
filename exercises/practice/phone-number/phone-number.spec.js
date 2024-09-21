import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./phone-number.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function clean(text) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(text).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, text);

  const [outputOffset, outputLength] = currentInstance.exports.clean(
    inputBufferOffset,
    inputLengthEncoded
  );

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Phone Number", () => {
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

  test("cleans the number", () => {
    const expected = "2234567890";
    const actual = clean("(223) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("cleans numbers with dots", () => {
    const expected = "2234567890";
    const actual = clean("223.456.7890");
    expect(actual).toEqual(expected);
  });

  xtest("cleans numbers with multiple spaces", () => {
    const expected = "2234567890";
    const actual = clean("223 456   7890   ");
    expect(actual).toEqual(expected);
  });

  xtest("invalid when 9 digits", () => {
    const expected = "";
    const actual = clean("123456789");
    expect(actual).toEqual(expected);
  });

  xtest("invalid when 11 digits does not start with a 1", () => {
    const expected = "";
    const actual = clean("22234567890");
    expect(actual).toEqual(expected);
  });

  xtest("valid when 11 digits and starting with 1", () => {
    const expected = "2234567890";
    const actual = clean("12234567890");
    expect(actual).toEqual(expected);
  });

  xtest("valid when 11 digits and starting with 1 even with punctuation", () => {
    const expected = "2234567890";
    const actual = clean("+1 (223) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid when more than 11 digits", () => {
    const expected = "";
    const actual = clean("321234567890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid with letters", () => {
    const expected = "";
    const actual = clean("523-abc-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid with punctuations", () => {
    const expected = "";
    const actual = clean("523-@:!-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if area code starts with 0", () => {
    const expected = "";
    const actual = clean("(023) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if area code starts with 1", () => {
    const expected = "";
    const actual = clean("(123) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if exchange code starts with 0", () => {
    const expected = "";
    const actual = clean("(223) 056-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if exchange code starts with 1", () => {
    const expected = "";
    const actual = clean("(223) 156-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if area code starts with 0 on valid 11-digit number", () => {
    const expected = "";
    const actual = clean("1 (023) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if area code starts with 1 on valid 11-digit number", () => {
    const expected = "";
    const actual = clean("1 (123) 456-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if exchange code starts with 0 on valid 11-digit number", () => {
    const expected = "";
    const actual = clean("1 (223) 056-7890");
    expect(actual).toEqual(expected);
  });

  xtest("invalid if exchange code starts with 1 on valid 11-digit number", () => {
    const expected = "";
    const actual = clean("1 (223) 156-7890");
    expect(actual).toEqual(expected);
  });
});
