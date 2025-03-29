import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./series.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});


const inputBufferOffset = 64;
const inputBufferCapacity = 128;

class Series {
  #inputLengthEncoded = 0;
  constructor(numbers) {
    this.#inputLengthEncoded = new TextEncoder().encode(numbers).length;
    if (this.#inputLengthEncoded > inputBufferCapacity) {
      throw new Error(
        `String is too large for buffer of size ${inputBufferCapacity} bytes`
      );
    }
  
    currentInstance.set_mem_as_utf8(inputBufferOffset, this.#inputLengthEncoded, numbers);
  }
  slices(length) {
    const [outputOffset, outputLength] = currentInstance.exports.slices(
      inputBufferOffset, this.#inputLengthEncoded, length
    );
    if (outputOffset < 0)
      throw new Error(this.#errors[outputOffset]);

    const outputArray = currentInstance.get_mem_as_u8(outputOffset, outputLength);
    const outputIterator = outputArray[Symbol.iterator]();

    return Array.from({ length: outputLength / length }, 
      () => Array.from({ length }, () => outputIterator.next()?.value));
  }
  #errors = {
    '-1': 'series cannot be empty',
    '-2': 'slice length cannot be greater than series length',
    '-3': 'slice length cannot be zero',
    '-4': 'slice length cannot be negative',
  }
}

describe('Series', () => {
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

  test('slices of one from one', () => {
    expect(new Series('1').slices(1)).toEqual([[1]]);
  });

  xtest('slices of one from two', () => {
    expect(new Series('12').slices(1)).toEqual([[1], [2]]);
  });

  xtest('slices of two', () => {
    expect(new Series('35').slices(2)).toEqual([[3, 5]]);
  });

  xtest('slices of two overlap', () => {
    expect(new Series('9142').slices(2)).toEqual([
      [9, 1],
      [1, 4],
      [4, 2],
    ]);
  });

  xtest('slices can include duplicates', () => {
    expect(new Series('777777').slices(3)).toEqual([
      [7, 7, 7],
      [7, 7, 7],
      [7, 7, 7],
      [7, 7, 7],
    ]);
  });

  xtest('slices of long series', () => {
    expect(new Series('918493904243').slices(5)).toEqual([
      [9, 1, 8, 4, 9],
      [1, 8, 4, 9, 3],
      [8, 4, 9, 3, 9],
      [4, 9, 3, 9, 0],
      [9, 3, 9, 0, 4],
      [3, 9, 0, 4, 2],
      [9, 0, 4, 2, 4],
      [0, 4, 2, 4, 3],
    ]);
  });

  xtest('slice length is too large', () => {
    expect(() => {
      new Series('12345').slices(6);
    }).toThrow(new Error('slice length cannot be greater than series length'));
  });

  xtest('slice length cannot be zero', () => {
    expect(() => {
      new Series('12345').slices(0);
    }).toThrow(new Error('slice length cannot be zero'));
  });

  xtest('slice length cannot be negative', () => {
    expect(() => {
      new Series('123').slices(-1);
    }).toThrow(new Error('slice length cannot be negative'));
  });

  xtest('empty series is invalid', () => {
    expect(() => {
      new Series('').slices(1);
    }).toThrow(new Error('series cannot be empty'));
  });
});