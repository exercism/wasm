import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./circular-buffer.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("CircularBuffer", () => {
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

  test("initializing negative capacity should error", () => {
    expect(currentInstance.exports.init(-1)).toEqual(-1);
  });

  xtest("initializing capacity of 0 i32s should result in a linear memory with 1 page", () => {
    expect(currentInstance.exports.init(0)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(1);
  });

  xtest("initializing capacity of 16384 i32s should result in a linear memory with 1 page", () => {
    expect(currentInstance.exports.init(16384)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(1);
  });

  xtest("initializing capacity of 16385 i32s should result in a linear memory with 2 pages", () => {
    expect(currentInstance.exports.init(16385)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(2);
  });

  xtest("initializing capacity of 32768 i32s should result in a linear memory with 2 pages", () => {
    expect(currentInstance.exports.init(32768)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(2);
  });

  xtest("initializing capacity of 32769 i32s should result in a linear memory with 3 pages", () => {
    expect(currentInstance.exports.init(32769)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(3);
  });

  xtest("initializing capacity of 49152 i32s should result in a linear memory with 3 pages", () => {
    expect(currentInstance.exports.init(49152)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(3);
  });

  xtest("initializing capacity of 49153 i32s should result in a linear memory with 4 pages", () => {
    expect(currentInstance.exports.init(49153)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(4);
  });

  xtest("initializing capacity of 65536 i32s should result in a linear memory with 4 pages", () => {
    expect(currentInstance.exports.init(65536)).toEqual(0);
    expect(currentInstance.exports.mem.buffer.byteLength / 65536).toEqual(4);
  });

  xtest("initializing capacity greater than 65536 should error", () => {
    expect(currentInstance.exports.init(65537)).toEqual(-1);
  });

  xtest("reading empty buffer should fail", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([-1, -1]);
  });

  xtest("can read an item just written", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
  });

  xtest("each item may only be read once", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.read()).toEqual([-1, -1]);
  });

  xtest("items are read in the order they are written", () => {
    expect(currentInstance.exports.init(2)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
  });

  xtest("full buffer can't be written to", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(-1);
  });

  xtest("a read frees up capacity for another write", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
  });

  xtest("read position is maintained even across multiple writes", () => {
    expect(currentInstance.exports.init(3)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.write(3)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
    expect(currentInstance.exports.read()).toEqual([3, 0]);
  });

  xtest("items cleared out of buffer can't be read", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    currentInstance.exports.clear();
    expect(currentInstance.exports.read()).toEqual([-1, -1]);
  });

  xtest("clear frees up capacity for another write", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    currentInstance.exports.clear();
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
  });

  xtest("clear does nothing on empty buffer", () => {
    expect(currentInstance.exports.init(1)).toEqual(0);
    currentInstance.exports.clear();
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
  });

  xtest("forceWrite acts like write on non-full buffer", () => {
    expect(currentInstance.exports.init(2)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.forceWrite(2)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
  });

  xtest("forceWrite replaces the oldest item on full buffer", () => {
    expect(currentInstance.exports.init(2)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.forceWrite(3)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([2, 0]);
    expect(currentInstance.exports.read()).toEqual([3, 0]);
  });

  xtest("forceWrite replaces the oldest item remaining in buffer following a read", () => {
    expect(currentInstance.exports.init(3)).toEqual(0);
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.write(3)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([1, 0]);
    expect(currentInstance.exports.write(4)).toEqual(0);
    expect(currentInstance.exports.forceWrite(5)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([3, 0]);
    expect(currentInstance.exports.read()).toEqual([4, 0]);
    expect(currentInstance.exports.read()).toEqual([5, 0]);
  });

  xtest("initial clear does not affect wrapping around", () => {
    expect(currentInstance.exports.init(2)).toEqual(0);
    currentInstance.exports.clear();
    expect(currentInstance.exports.write(1)).toEqual(0);
    expect(currentInstance.exports.write(2)).toEqual(0);
    expect(currentInstance.exports.forceWrite(3)).toEqual(0);
    expect(currentInstance.exports.forceWrite(4)).toEqual(0);
    expect(currentInstance.exports.read()).toEqual([3, 0]);
    expect(currentInstance.exports.read()).toEqual([4, 0]);
    expect(currentInstance.exports.read()).toEqual([-1, -1]);
  });

  xtest("Should be able to write and read up to the full capacity of four 64Kib pages", () => {
    expect(currentInstance.exports.init(65536)).toEqual(0);
    for (let i = 0; i < 65536; i++) {
      expect(currentInstance.exports.write(i)).toEqual(0);
    }
    for (let i = 0; i < 65536; i++) {
      expect(currentInstance.exports.read()).toEqual([i, 0]);
    }
  });
});
