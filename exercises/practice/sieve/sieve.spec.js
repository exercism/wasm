import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./sieve.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function primes(limit) {
  const [outputOffset, outputLength] = currentInstance.exports.primes(limit);

  const outputBuffer = currentInstance.get_mem_as_i32(
    outputOffset,
    outputLength
  );

  return [...outputBuffer];
}

describe("Sieve of Eratosthenes", () => {
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

  test("no primes under two", () => {
    expect(primes(1)).toEqual([]);
  });

  xtest("find first prime", () => {
    expect(primes(2)).toEqual([2]);
  });

  xtest("find primes up to 10", () => {
    expect(primes(10)).toEqual([2, 3, 5, 7]);
  });

  xtest("limit is prime", () => {
    expect(primes(13)).toEqual([2, 3, 5, 7, 11, 13]);
  });

  xtest("find primes up to 1000", () => {
    expect(primes(1000)).toEqual([
        2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,  41,  43,
       47,  53,  59,  61,  67,  71,  73,  79,  83,  89,  97, 101, 103, 107,
      109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181,
      191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263,
      269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349,
      353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433,
      439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521,
      523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613,
      617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701,
      709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809,
      811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
      907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
    ]);
  });

});
