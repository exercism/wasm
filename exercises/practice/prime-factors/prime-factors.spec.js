import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./prime-factors.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const primeFactors = (num) => {
  const [outputOffset, outputLength] = currentInstance.exports.primeFactors(BigInt(num));
  return [...currentInstance.get_mem_as_u32(outputOffset, outputLength)];
}

describe('returns prime factors for the given input number', () => {
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

  test('no factors', () => expect(primeFactors(1)).toEqual([]));

  xtest('prime number', () => expect(primeFactors(2)).toEqual([2]));

  xtest('another prime number', () => expect(primeFactors(3)).toEqual([3]));

  xtest('square of a prime', () => expect(primeFactors(9)).toEqual([3, 3]));

  xtest('product of first prime', () =>
    expect(primeFactors(4)).toEqual([2, 2]));

  xtest('cube of a prime', () => expect(primeFactors(8)).toEqual([2, 2, 2]));

  xtest('product of second prime', () =>
    expect(primeFactors(27)).toEqual([3, 3, 3]));

  xtest('product of third prime', () =>
    expect(primeFactors(625)).toEqual([5, 5, 5, 5]));

  xtest('product of first prime and second prime', () =>
    expect(primeFactors(6)).toEqual([2, 3]));

  xtest('product of primes and non-primes', () =>
    expect(primeFactors(12)).toEqual([2, 2, 3]));

  xtest('product of primes', () =>
    expect(primeFactors(901255)).toEqual([5, 17, 23, 461]));

  xtest('factors include a large prime', () =>
    expect(primeFactors(93819012551)).toEqual([11, 9539, 894119]));
});