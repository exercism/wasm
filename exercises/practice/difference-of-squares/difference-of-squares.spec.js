import { compileWat } from './compile-wat';

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("difference-of-squares.wat");
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});


describe('difference-of-squares', () => {
  beforeEach(async (done) => {
    currentInstance = null;

    if (!wasmModule) {
      done();
      return;
    }
    try {
      currentInstance = await WebAssembly.instantiate(wasmModule);
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
    }
    done();
  });


  describe('Square the sum of the numbers up to the given number', () => {
    test('square of sum 1', () => {
      expect(currentInstance.exports.squareOfSum(1)).toBe(1);
    });

    test('square of sum 5', () => {
      expect(currentInstance.exports.squareOfSum(5)).toBe(225);
    });

    test('square of sum 100', () => {
      expect(currentInstance.exports.squareOfSum(100)).toBe(25502500);
    });
  });

  describe('Sum the squares of the numbers up to the given number', () => {
    test('sum of squares 1', () => {
      expect(currentInstance.exports.sumOfSquares(1)).toBe(1);
    });

    test('sum of squares 5', () => {
      expect(currentInstance.exports.sumOfSquares(5)).toBe(55);
    });

    test('sum of squares 100', () => {
      expect(currentInstance.exports.sumOfSquares(100)).toBe(338350);
    });
  });

  describe('Subtract sum of squares from square of sums', () => {
    test('difference of squares 1', () => {
      expect(currentInstance.exports.difference(1)).toBe(0);
    });

    test('difference of squares 5', () => {
      expect(currentInstance.exports.difference(5)).toBe(170);
    });

    test('difference of squares 100', () => {
      expect(currentInstance.exports.difference(100)).toBe(25164150);
    });
  });
});
