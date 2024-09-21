import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./roman-numerals.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function roman(input) {
  const [outputOffset, outputLength] = currentInstance.exports.roman(input);

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Roman Numerals", () => {
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

  test("1 is I", () => {
    const expected = "I";
    const actual = roman(1);
    expect(actual).toEqual(expected);
  });

  xtest("2 is II", () => {
    const expected = "II";
    const actual = roman(2);
    expect(actual).toEqual(expected);
  });

  xtest("3 is III", () => {
    const expected = "III";
    const actual = roman(3);
    expect(actual).toEqual(expected);
  });

  xtest("4 is IV", () => {
    const expected = "IV";
    const actual = roman(4);
    expect(actual).toEqual(expected);
  });

  xtest("5 is V", () => {
    const expected = "V";
    const actual = roman(5);
    expect(actual).toEqual(expected);
  });

  xtest("6 is VI", () => {
    const expected = "VI";
    const actual = roman(6);
    expect(actual).toEqual(expected);
  });

  xtest("9 is IX", () => {
    const expected = "IX";
    const actual = roman(9);
    expect(actual).toEqual(expected);
  });

  xtest("16 is XVI", () => {
    const expected = "XVI";
    const actual = roman(16);
    expect(actual).toEqual(expected);
  });

  xtest("27 is XXVII", () => {
    const expected = "XXVII";
    const actual = roman(27);
    expect(actual).toEqual(expected);
  });

  xtest("48 is XLVIII", () => {
    const expected = "XLVIII";
    const actual = roman(48);
    expect(actual).toEqual(expected);
  });

  xtest("49 is XLIX", () => {
    const expected = "XLIX";
    const actual = roman(49);
    expect(actual).toEqual(expected);
  });

  xtest("59 is LIX", () => {
    const expected = "LIX";
    const actual = roman(59);
    expect(actual).toEqual(expected);
  });

  xtest("66 is LXVI", () => {
    const expected = "LXVI";
    const actual = roman(66);
    expect(actual).toEqual(expected);
  });

  xtest("93 is XCIII", () => {
    const expected = "XCIII";
    const actual = roman(93);
    expect(actual).toEqual(expected);
  });

  xtest("141 is CXLI", () => {
    const expected = "CXLI";
    const actual = roman(141);
    expect(actual).toEqual(expected);
  });

  xtest("163 is CLXIII", () => {
    const expected = "CLXIII";
    const actual = roman(163);
    expect(actual).toEqual(expected);
  });

  xtest("166 is CLXVI", () => {
    const expected = "CLXVI";
    const actual = roman(166);
    expect(actual).toEqual(expected);
  });

  xtest("402 is CDII", () => {
    const expected = "CDII";
    const actual = roman(402);
    expect(actual).toEqual(expected);
  });

  xtest("575 is DLXXV", () => {
    const expected = "DLXXV";
    const actual = roman(575);
    expect(actual).toEqual(expected);
  });

  xtest("666 is DCLXVI", () => {
    const expected = "DCLXVI";
    const actual = roman(666);
    expect(actual).toEqual(expected);
  });

  xtest("911 is CMXI", () => {
    const expected = "CMXI";
    const actual = roman(911);
    expect(actual).toEqual(expected);
  });

  xtest("1024 is MXXIV", () => {
    const expected = "MXXIV";
    const actual = roman(1024);
    expect(actual).toEqual(expected);
  });

  xtest("1666 is MDCLXVI", () => {
    const expected = "MDCLXVI";
    const actual = roman(1666);
    expect(actual).toEqual(expected);
  });

  xtest("3000 is MMM", () => {
    const expected = "MMM";
    const actual = roman(3000);
    expect(actual).toEqual(expected);
  });

  xtest("3001 is MMMI", () => {
    const expected = "MMMI";
    const actual = roman(3001);
    expect(actual).toEqual(expected);
  });

  xtest("3888 is MMMDCCCLXXXVIII", () => {
    const expected = "MMMDCCCLXXXVIII";
    const actual = roman(3888);
    expect(actual).toEqual(expected);
  });

  xtest("3999 is MMMCMXCIX", () => {
    const expected = "MMMCMXCIX";
    const actual = roman(3999);
    expect(actual).toEqual(expected);
  });
});
