import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./state-of-tic-tac-toe.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const gamestates = {
  '0': 'ongoing',
  '1': 'draw',
  '2': 'win',
  '-1': new Error('Wrong turn order: X went twice'),
  '-2': new Error('Wrong turn order: O started'),
  '-3': new Error('Impossible board: game should have ended after the game was won'),
};

export const gamestate = (board) => {
  const input = board.join('\n');
  const inputBufferOffset = 64;
  const inputBufferCapacity = 128;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  const state = gamestates[currentInstance.exports.gamestate(
    inputBufferOffset,
    inputLengthEncoded
  )];

  if (state instanceof Error)
    throw state;

  return state;
}

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

describe('Won games', () => {
  test('Finished game where X won via left column victory', () => {
    const board = ['XOO', 'X  ', 'X  '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via middle column victory', () => {
    const board = ['OXO', ' X ', ' X '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via right column victory', () => {
    const board = ['OOX', '  X', '  X'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via left column victory', () => {
    const board = ['OXX', 'OX ', 'O  '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via middle column victory', () => {
    const board = ['XOX', ' OX', ' O '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via right column victory', () => {
    const board = ['XXO', ' XO', '  O'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via top row victory', () => {
    const board = ['XXX', 'XOO', 'O  '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via middle row victory', () => {
    const board = ['O  ', 'XXX', ' O '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via bottom row victory', () => {
    const board = [' OO', 'O X', 'XXX'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via top row victory', () => {
    const board = ['OOO', 'XXO', 'XX '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via middle row victory', () => {
    const board = ['XX ', 'OOO', 'X  '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via bottom row victory', () => {
    const board = ['XOX', ' XX', 'OOO'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via falling diagonal victory', () => {
    const board = ['XOO', ' X ', '  X'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via rising diagonal victory', () => {
    const board = ['O X', 'OX ', 'X  '];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via falling diagonal victory', () => {
    const board = ['OXX', 'OOX', 'X O'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where O won via rising diagonal victory', () => {
    const board = ['  O', ' OX', 'OXX'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via a row and a column victory', () => {
    const board = ['XXX', 'XOO', 'XOO'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Finished game where X won via two diagonal victories', () => {
    const board = ['XOX', 'OXO', 'XOX'];
    const expected = 'win';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });
});

describe('Draw games', () => {
  xtest('Draw', () => {
    const board = ['XOX', 'XXO', 'OXO'];
    const expected = 'draw';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Another draw', () => {
    const board = ['XXO', 'OXX', 'XOO'];
    const expected = 'draw';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });
});

describe('Ongoing games', () => {
  xtest('Ongoing game: one move in', () => {
    const board = ['   ', 'X  ', '   '];
    const expected = 'ongoing';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Ongoing game: two moves in', () => {
    const board = ['O  ', ' X ', '   '];
    const expected = 'ongoing';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });

  xtest('Ongoing game: five moves in', () => {
    const board = ['X  ', ' XO', 'OX '];
    const expected = 'ongoing';
    const actual = gamestate(board);
    expect(actual).toEqual(expected);
  });
});

describe('Invalid boards', () => {
  xtest('Invalid board: X went twice', () => {
    const board = ['XX ', '   ', '   '];
    const expected = new Error('Wrong turn order: X went twice');
    const actual = () => gamestate(board);
    expect(actual).toThrow(expected);
  });

  xtest('Invalid board: O started', () => {
    const board = ['OOX', '   ', '   '];
    const expected = new Error('Wrong turn order: O started');
    const actual = () => gamestate(board);
    expect(actual).toThrow(expected);
  });

  xtest('Invalid board: X won and O kept playing', () => {
    const board = ['XXX', 'OOO', '   '];
    const expected = new Error(
      'Impossible board: game should have ended after the game was won',
    );
    const actual = () => gamestate(board);
    expect(actual).toThrow(expected);
  });

  xtest('Invalid board: players kept playing after a win', () => {
    const board = ['XXX', 'OOO', 'XOX'];
    const expected = new Error(
      'Impossible board: game should have ended after the game was won',
    );
    const actual = () => gamestate(board);
    expect(actual).toThrow(expected);
  });
});