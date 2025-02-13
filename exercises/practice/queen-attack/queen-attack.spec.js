import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./queen-attack.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

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

class QueenAttack {
  constructor({ black = [0, 3], white = [7, 3] } = {}) {
    this.positions = (white[0] << 24) | (white[1] << 16) | (black[0] << 8) | black[1];
    this.canAttack = [false, true][currentInstance.exports.canAttack(this.positions)] ??
      (() => { throw new Error("invalid positions") })();
  }
  toString() {
    const [outputOffset, outputLength] = currentInstance.exports.printBoard(this.positions);
    return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  }
}

describe('Queens', () => {
    describe('Test creation of Queens with valid and invalid positions', () => {
      test('queen with a valid position', () => {
        expect(() => new QueenAttack({ white: [2, 2] })).not.toThrow();
      });
  
      xtest('queen must have positive row', () => {
        const positioning = { white: [-2, 2] };
        const expectedError = 'invalid positions';
        expect(() => new QueenAttack(positioning)).toThrow(expectedError);
      });
  
      xtest('queen must have row on board', () => {
        const positioning = { white: [8, 4] };
        const expectedError = 'invalid positions';
        expect(() => new QueenAttack(positioning)).toThrow(expectedError);
      });
  
      xtest('queen must have positive column', () => {
        const positioning = { white: [2, -2] };
        const expectedError = 'invalid positions';
        expect(() => new QueenAttack(positioning)).toThrow(expectedError);
      });
  
      xtest('queen must have column on board', () => {
        const positioning = { white: [4, 8] };
        const expectedError = 'invalid positions';
        expect(() => new QueenAttack(positioning)).toThrow(expectedError);
      });
  
      xtest('two queens cannot occupy the same space', () => {
        const positioning = { white: [2, 4], black: [2, 4] };
        const expectedError = 'invalid positions';
        expect(() => new QueenAttack(positioning)).toThrow(expectedError);
      });
    });
  
    describe('Test the ability of one queen to attack another', () => {
      xtest('queens cannot attack', () => {
        const queens = new QueenAttack({ white: [2, 4], black: [6, 6] });
        expect(queens.canAttack).toEqual(false);
      });
  
      xtest('queens can attack when they are on the same row', () => {
        const queens = new QueenAttack({ white: [2, 4], black: [2, 6] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack when they are on the same column', () => {
        const queens = new QueenAttack({ white: [4, 5], black: [2, 5] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack diagonally', () => {
        const queens = new QueenAttack({ white: [2, 2], black: [0, 4] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack another diagonally', () => {
        const queens = new QueenAttack({ white: [2, 2], black: [3, 1] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack yet another diagonally', () => {
        const queens = new QueenAttack({ white: [2, 2], black: [1, 1] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack diagonally, really', () => {
        const queens = new QueenAttack({ white: [1, 7], black: [0, 6] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack on a north-east/south-west diagonal', () => {
        const queens = new QueenAttack({ white: [7, 0], black: [0, 7] });
        expect(queens.canAttack).toEqual(true);
      });
  
      xtest('queens can attack on another ne/sw diagonal', () => {
        const queens = new QueenAttack({ white: [2, 6], black: [5, 3] });
        expect(queens.canAttack).toEqual(true);
      });
    });
  
    describe('Test the board visualisation', () => {
      xtest('board', () => {
        const positioning = { white: [3, 2], black: [6, 5] };
        const queens = new QueenAttack(positioning);
        const board = [
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ W _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ B _ _',
          '_ _ _ _ _ _ _ _',
          '',
        ].join('\n');
        expect(queens.toString()).toEqual(board);
      });
  
      xtest('board with queens at their starting positions', () => {
        const queens = new QueenAttack();
        const board = [
          '_ _ _ B _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ W _ _ _ _',
          '',
        ].join('\n');
        expect(queens.toString()).toEqual(board);
      });
  
      xtest('board with the black queen at her starting positions', () => {
        const queens = new QueenAttack({ white: [1, 6] });
        const board = [
          '_ _ _ B _ _ _ _',
          '_ _ _ _ _ _ W _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '',
        ].join('\n');
        expect(queens.toString()).toEqual(board);
      });
  
      xtest('board with queens at the edges', () => {
        const positioning = { white: [0, 0], black: [7, 7] };
        const queens = new QueenAttack(positioning);
        const board = [
          'W _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ _',
          '_ _ _ _ _ _ _ B',
          '',
        ].join('\n');
        expect(queens.toString()).toEqual(board);
      });
    });
  });
