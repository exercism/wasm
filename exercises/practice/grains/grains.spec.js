import { compileWat } from './compile-wat';

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("grains.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

describe('Grains', () => {
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

  describe('returns the number of grains on the square', () => {
    test('grains on square 1', () => {
      let resultSigned = currentInstance.exports.square(1n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(1n);
    });

    xtest('grains on square 2', () => {
      let resultSigned = currentInstance.exports.square(2n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(2n);
    });

    xtest('grains on square 3', () => {
      let resultSigned = currentInstance.exports.square(3n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(4n);
    });

    xtest('grains on square 4', () => {
      let resultSigned = currentInstance.exports.square(4n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(8n);
    });

    xtest('grains on square 16', () => {
      let resultSigned = currentInstance.exports.square(16n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(32768n);
    });

    xtest('grains on square 32', () => {
      let resultSigned = currentInstance.exports.square(32n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(2147483648n);
    });

    xtest('grains on square 64', () => {
      let resultSigned = currentInstance.exports.square(64n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(9223372036854775808n);
    });

    xtest('square 0 has no value', () => {
      let resultSigned = currentInstance.exports.square(0n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(0n);
    });

    xtest('negative square has no value', () => {
      let resultSigned = currentInstance.exports.square(-1n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(0n);
    });

    xtest('square greater than 64 has no value', () => {
      let resultSigned = currentInstance.exports.square(65n)
      let resultUnsigned = BigInt.asUintN(64, resultSigned);
      expect(resultUnsigned).toEqual(0n);
    });
  });

  xtest('returns the total number of grains on the board', () => {
    let resultSigned = currentInstance.exports.total()
    let resultUnsigned = BigInt.asUintN(64, resultSigned);
    expect(resultUnsigned).toEqual(18446744073709551615n);
  });
});
