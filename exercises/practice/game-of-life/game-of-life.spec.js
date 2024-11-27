import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./game-of-life.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function next(input) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;
  const cells = input.flat();
  const rows = input.length;
  const cols = cells.length / rows;

  if (cells.length > inputBufferCapacity)
    throw new Error(`Matrix is too large for buffer of size ${inputBufferCapacity} byte`);

  // write current
  const inputSegment = currentInstance.get_mem_as_u8(
    inputBufferOffset,
    cells.length
  );
  inputSegment.set(cells, 0);

  // Pass offset, cols and rows to WebAssembly function
  const outputOffset = currentInstance.exports.next(
    inputBufferOffset,
    cols,
    rows
  );

  const outputSegment = currentInstance.get_mem_as_u8(
    outputOffset,
    cells.length
  )
  
  // decode the same matrix from the returned offset
  const output = [...outputSegment.values()].reduce(
      (board, cell) => {
          if (board.length === 0 || board.at(-1).length === cols) board.push([]);
          board.at(-1).push(cell);
          return board;
      },
      []
  );

  return output;
}

// serialize the matrix to make the output more helpful
const serialize = (matrix) =>
  matrix.map(line => line.join('')).join('\n');

describe("Game of Life", () => {
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

  test("live cell with zero neighbors dies", () => {
    const expected = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
    ];
    const actual = next([
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("live cells with only one neighbor dies", () => {
    const expected = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
    ];
    const actual = next([
        [0, 0, 0],
        [0, 1, 0],
        [0, 1, 0]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("live cells with two neighbors stay alive", () => {
    const expected = [
        [0, 0, 0],
        [1, 0, 1],
        [0, 0, 0]
    ];
    const actual = next([
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("live cells with three neighbors stay alive", () => {
    const expected = [
        [0, 0, 0],
        [1, 0, 0],
        [1, 1, 0]
    ];
    const actual = next([
        [0, 1, 0],
        [1, 0, 0],
        [1, 1, 0]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("dead cells with three neighbors come alive", () => {
    const expected = [
        [0, 0, 0],
        [1, 1, 0],
        [0, 0, 0]
    ];
    const actual = next([
        [1, 1, 0],
        [0, 0, 0],
        [1, 0, 0]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("live cells with four or more neighbors dies", () => {
    const expected = [
        [1, 0, 1],
        [0, 0, 0],
        [1, 0, 1]
    ];
    const actual = next([
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });

  xtest("bigger matrix", () => {
    const expected = [
        [1, 1, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 1, 0],
        [1, 0, 1, 1, 1, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 1, 0, 0, 1],
        [1, 1, 0, 1, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 1]
    ];
    const actual = next([
        [1, 1, 0, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 0],
        [1, 0, 0, 0, 1, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 1, 1],
        [0, 0, 1, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 1, 1]
    ]);
    expect(serialize(actual)).toEqual(serialize(expected));
  });
});
