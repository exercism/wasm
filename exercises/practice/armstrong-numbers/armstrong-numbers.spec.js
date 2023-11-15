import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./armstrong-numbers.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("Armstrong Numbers", () => {
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

  test("Zero is an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(0)).toEqual(1);
  });

  xtest("Single digit numbers are Armstrong numbers", () => {
    expect(currentInstance.exports.isArmstrongNumber(5)).toEqual(1);
  });

  xtest("There are no 2 digit Armstrong numbers", () => {
    expect(currentInstance.exports.isArmstrongNumber(10)).toEqual(0);
  });

  xtest("Three digit number that is an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(153)).toEqual(1);
  });

  xtest("Three digit number that is not an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(100)).toEqual(0);
  });

  xtest("Four digit number that is an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(9474)).toEqual(1);
  });

  xtest("Four digit number that is not an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(9475)).toEqual(0);
  });

  xtest("Seven digit number that is an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(9926315)).toEqual(1);
  });

  xtest("Seven digit number that is not an Armstrong number", () => {
    expect(currentInstance.exports.isArmstrongNumber(9926314)).toEqual(0);
  });
});
