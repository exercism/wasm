import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./sublist.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

class List {
  constructor(items = []) {
    this.items = items;
  }
  compare(other) {
    const inputBufferOffset = 64;
    const inputBufferCapacity = 256;
    const firstListOffset = inputBufferOffset;
    const firstListLength = this.items.length;
    const secondListOffset = inputBufferOffset + firstListLength;
    const secondListLength = other.items.length;

    const mem = currentInstance.get_mem_as_u8(inputBufferOffset, inputBufferCapacity);
    mem.set(this.items);
    mem.set(other.items, firstListLength);

    // Pass offset and length to WebAssembly function
    const result = currentInstance.exports.compare(
      firstListOffset,
      firstListLength,
      secondListOffset,
      secondListLength
    );

    return ['UNEQUAL', 'SUBLIST', 'EQUAL', 'SUPERLIST'][result];
  }
}

describe('sublist', () => {
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
  
  xtest('two empty lists are equal', () => {
    const listOne = new List();
    const listTwo = new List();

    expect(listOne.compare(listTwo)).toEqual('EQUAL');
  });

  xtest('an empty list is a sublist of a non-empty list', () => {
    const listOne = new List();
    const listTwo = new List([1, 2, 3]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('non empty list contains empty list', () => {
    const listOne = new List([1, 2, 3]);
    const listTwo = new List();

    expect(listOne.compare(listTwo)).toEqual('SUPERLIST');
  });

  test('a non-empty list equals itself', () => {
    const listOne = new List([1, 2, 3]);
    const listTwo = new List([1, 2, 3]);

    expect(listOne.compare(listTwo)).toEqual('EQUAL');
  });

  xtest('two different lists are unequal', () => {
    const listOne = new List([1, 2, 3]);
    const listTwo = new List([2, 3, 4]);

    expect(listOne.compare(listTwo)).toEqual('UNEQUAL');
  });

  xtest('false start', () => {
    const listOne = new List([1, 2, 5]);
    const listTwo = new List([0, 1, 2, 3, 1, 2, 5, 6]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('consecutive', () => {
    const listOne = new List([1, 1, 2]);
    const listTwo = new List([0, 1, 1, 1, 2, 1, 2]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('sublist at start', () => {
    const listOne = new List([0, 1, 2]);
    const listTwo = new List([0, 1, 2, 3, 4, 5]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('sublist in middle', () => {
    const listOne = new List([2, 3, 4]);
    const listTwo = new List([0, 1, 2, 3, 4, 5]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('sublist at end', () => {
    const listOne = new List([3, 4, 5]);
    const listTwo = new List([0, 1, 2, 3, 4, 5]);

    expect(listOne.compare(listTwo)).toEqual('SUBLIST');
  });

  xtest('at start of superlist', () => {
    const listOne = new List([0, 1, 2, 3, 4, 5]);
    const listTwo = new List([0, 1, 2]);

    expect(listOne.compare(listTwo)).toEqual('SUPERLIST');
  });

  xtest('in middle of superlist', () => {
    const listOne = new List([0, 1, 2, 3, 4, 5]);
    const listTwo = new List([2, 3]);

    expect(listOne.compare(listTwo)).toEqual('SUPERLIST');
  });

  xtest('at end of superlist', () => {
    const listOne = new List([0, 1, 2, 3, 4, 5]);
    const listTwo = new List([3, 4, 5]);

    expect(listOne.compare(listTwo)).toEqual('SUPERLIST');
  });

  xtest('first list missing element from second list', () => {
    const listOne = new List([1, 3]);
    const listTwo = new List([1, 2, 3]);

    expect(listOne.compare(listTwo)).toEqual('UNEQUAL');
  });

  xtest('second list missing element from first list', () => {
    const listOne = new List([1, 2, 3]);
    const listTwo = new List([1, 3]);

    expect(listOne.compare(listTwo)).toEqual('UNEQUAL');
  });

  xtest('order matters to a list', () => {
    const listOne = new List([1, 2, 3]);
    const listTwo = new List([3, 2, 1]);

    expect(listOne.compare(listTwo)).toEqual('UNEQUAL');
  });

  xtest('same digits but different numbers', () => {
    const listOne = new List([1, 0, 1]);
    const listTwo = new List([10, 1]);

    expect(listOne.compare(listTwo)).toEqual('UNEQUAL');
  });
});