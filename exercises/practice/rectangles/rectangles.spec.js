import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./rectangles.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function count(input) {
  input = input.join('\n') + '\n';

  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  // Pass offset and length to WebAssembly function
  const rectangleCount = currentInstance.exports.count(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return rectangleCount;

}
    
describe('Rectangles', () => {
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
  test('no rows', () => {
    const expected = 0;
    const actual = count([]);

    expect(actual).toEqual(expected);
  });

  xtest('no columns', () => {
    const expected = 0;
    const actual = count(['']);

    expect(actual).toEqual(expected);
  });

  xtest('no rectangles', () => {
    const expected = 0;
    const actual = count([' ']);

    expect(actual).toEqual(expected);
  });

  xtest('one rectangle', () => {
    const expected = 1;
    const actual = count(['+-+', '| |', '+-+']);

    expect(actual).toEqual(expected);
  });

  xtest('two rectangles without shared parts', () => {
    const expected = 2;
    const actual = count(['  +-+', '  | |', '+-+-+', '| |  ', '+-+  ']);

    expect(actual).toEqual(expected);
  });

  xtest('five rectangles with shared parts', () => {
    const expected = 5;
    const actual = count(['  +-+', '  | |', '+-+-+', '| | |', '+-+-+']);

    expect(actual).toEqual(expected);
  });

  xtest('rectangle of height 1 is counted', () => {
    const expected = 1;
    const actual = count(['+--+', '+--+']);

    expect(actual).toEqual(expected);
  });

  xtest('rectangle of width 1 is counted', () => {
    const expected = 1;
    const actual = count(['++', '||', '++']);

    expect(actual).toEqual(expected);
  });

  xtest('1x1 square is counted', () => {
    const expected = 1;
    const actual = count(['++', '++']);

    expect(actual).toEqual(expected);
  });

  xtest('only complete rectangles are counted', () => {
    const expected = 1;
    const actual = count(['  +-+', '    |', '+-+-+', '| | -', '+-+-+']);

    expect(actual).toEqual(expected);
  });

  xtest('rectangles can be of different sizes', () => {
    const expected = 3;
    const actual = count([
      '+------+----+',
      '|      |    |',
      '+---+--+    |',
      '|   |       |',
      '+---+-------+',
    ]);

    expect(actual).toEqual(expected);
  });

  xtest('corner is required for a rectangle to be complete', () => {
    const expected = 2;
    const actual = count([
      '+------+----+',
      '|      |    |',
      '+------+    |',
      '|   |       |',
      '+---+-------+',
    ]);

    expect(actual).toEqual(expected);
  });

  xtest('large input with many rectangles', () => {
    const expected = 60;
    const actual = count([
      '+---+--+----+',
      '|   +--+----+',
      '+---+--+    |',
      '|   +--+----+',
      '+---+--+--+-+',
      '+---+--+--+-+',
      '+------+  | |',
      '          +-+',
    ]);

    expect(actual).toEqual(expected);
  });

  xtest('rectangles must have four sides', () => {
    const expected = 5;
    const actual = count([
      '+-+ +-+',
      '| | | |',
      '+-+-+-+',
      '  | |  ',
      '+-+-+-+',
      '| | | |',
      '+-+ +-+',
    ]);

    expect(actual).toEqual(expected);
  });
});