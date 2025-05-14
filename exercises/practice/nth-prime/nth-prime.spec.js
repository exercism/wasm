import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./nth-prime.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const prime = (nth) => currentInstance.exports.prime(nth);

describe('nth-prime', () => {
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

  test('first prime', () => {
    expect(prime(1)).toEqual(2);
  });

  xtest('second prime', () => {
    expect(prime(2)).toEqual(3);
  });

  xtest('sixth prime', () => {
    expect(prime(6)).toEqual(13);
  });

  xtest('big prime', () => {
    expect(prime(10001)).toEqual(104743);
  });
});
