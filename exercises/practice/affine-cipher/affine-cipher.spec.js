import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./affine-cipher.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function codec(func) {
  return function(input, key) {
    if (!input)
      throw new Error(`nothing to ${func}`);
    
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
    const [outputOffset, outputLength] = currentInstance.exports[func](
      inputBufferOffset,
      input.length,
      key.a,
      key.b
    );

    if (outputLength === 0)
      throw new Error('a and m must be coprime.')

    // Decode JS string from returned offset and length
    return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  }
}

const encode = codec('encode');
const decode = codec('decode');
  
describe('Affine cipher', () => {
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
  describe('encode', () => {
    test('encode yes', () => {
      expect(encode('yes', { a: 5, b: 7 })).toBe('xbt');
    });

    xtest('encode no', () => {
      expect(encode('no', { a: 15, b: 18 })).toBe('fu');
    });

    xtest('encode OMG', () => {
      expect(encode('OMG', { a: 21, b: 3 })).toBe('lvz');
    });

    xtest('encode O M G', () => {
      expect(encode('O M G', { a: 25, b: 47 })).toBe('hjp');
    });

    xtest('encode mindblowingly', () => {
      expect(encode('mindblowingly', { a: 11, b: 15 })).toBe('rzcwa gnxzc dgt');
    });

    xtest('encode numbers', () => {
      expect(encode('Testing,1 2 3, testing.', { a: 3, b: 4 })).toBe(
        'jqgjc rw123 jqgjc rw',
      );
    });

    xtest('encode deep thought', () => {
      expect(encode('Truth is fiction.', { a: 5, b: 17 })).toBe(
        'iynia fdqfb ifje',
      );
    });

    xtest('encode all the letters', () => {
      expect(
        encode('The quick brown fox jumps over the lazy dog.', {
          a: 17,
          b: 33,
        }),
      ).toBe('swxtj npvyk lruol iejdc blaxk swxmh qzglf');
    });

    xtest('encode with a not coprime to m', () => {
      expect(() => {
        encode('This is a test.', { a: 6, b: 17 });
      }).toThrow('a and m must be coprime.');
    });
  });
  describe('decode', () => {
    test('decode exercism', () => {
      expect(decode('tytgn fjr', { a: 3, b: 7 })).toBe('exercism');
    });

    xtest('decode a sentence', () => {
      expect(
        decode('qdwju nqcro muwhn odqun oppmd aunwd o', { a: 19, b: 16 }),
      ).toBe('anobstacleisoftenasteppingstone');
    });

    xtest('decode numbers', () => {
      expect(decode('odpoz ub123 odpoz ub', { a: 25, b: 7 })).toBe(
        'testing123testing',
      );
    });

    xtest('decode all the letters', () => {
      expect(
        decode('swxtj npvyk lruol iejdc blaxk swxmh qzglf', { a: 17, b: 33 }),
      ).toBe('thequickbrownfoxjumpsoverthelazydog');
    });

    xtest('decode with no spaces in input', () => {
      expect(
        decode('swxtjnpvyklruoliejdcblaxkswxmhqzglf', { a: 17, b: 33 }),
      ).toBe('thequickbrownfoxjumpsoverthelazydog');
    });

    xtest('decode with too many spaces', () => {
      expect(decode('vszzm    cly   yd cg    qdp', { a: 15, b: 16 })).toBe(
        'jollygreengiant',
      );
    });

    xtest('decode with a not coprime to m', () => {
      expect(() => {
        decode('Test', { a: 13, b: 5 });
      }).toThrow('a and m must be coprime.');
    });
  });
});
