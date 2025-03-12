import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./anagram.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const findAnagrams = (word, candidates) => {
  const input = [word, ...candidates].join('\n') + '\n';
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
  const [outputOffset, outputLength] = currentInstance.exports.findAnagrams(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  const output = currentInstance.get_mem_as_utf8(outputOffset, outputLength);

  return output ? output.trim().split('\n') : [];
}

describe('Anagram', () => {
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

  test('no matches', () => {
    const expected = [];
    const actual = findAnagrams('diaper', [
      'hello',
      'world',
      'zombies',
      'pants',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects two anagrams', () => {
    const expected = ['lemons', 'melons'];
    const actual = findAnagrams('solemn', ['lemons', 'cherry', 'melons']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('does not detect anagram subsets', () => {
    const expected = [];
    const actual = findAnagrams('good', ['dog', 'goody']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects anagram', () => {
    const expected = ['inlets'];
    const actual = findAnagrams('listen', [
      'enlists',
      'google',
      'inlets',
      'banana',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects three anagrams', () => {
    const expected = ['gallery', 'regally', 'largely'];
    const actual = findAnagrams('allergy', [
      'gallery',
      'ballerina',
      'regally',
      'clergy',
      'largely',
      'leading',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects multiple anagrams with different case', () => {
    const expected = ['Eons', 'ONES'];
    const actual = findAnagrams('nose', ['Eons', 'ONES']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('does not detect non-anagrams with identical checksum', () => {
    const expected = [];
    const actual = findAnagrams('mass', ['last']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects anagrams case-insensitively', () => {
    const expected = ['Carthorse'];
    const actual = findAnagrams('Orchestra', [
      'cashregister',
      'Carthorse',
      'radishes',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects anagrams using case-insensitive subject', () => {
    const expected = ['carthorse'];
    const actual = findAnagrams('Orchestra', [
      'cashregister',
      'carthorse',
      'radishes',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('detects anagrams using case-insensitive possible matches', () => {
    const expected = ['Carthorse'];
    const actual = findAnagrams('orchestra', [
      'cashregister',
      'Carthorse',
      'radishes',
    ]);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('does not detect an anagram if the original word is repeated', () => {
    const expected = [];
    const actual = findAnagrams('go', ['go Go GO']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('anagrams must use all letters exactly once', () => {
    const expected = [];
    const actual = findAnagrams('tapper', ['patter']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('words are not anagrams of themselves (case-insensitive)', () => {
    const expected = [];
    const actual = findAnagrams('BANANA', ['BANANA', 'Banana', 'banana']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });

  xtest('words other than themselves can be anagrams', () => {
    const expected = ['Silent'];
    const actual = findAnagrams('LISTEN', ['Listen', 'Silent', 'LISTEN']);
    expect(new Set(expected)).toEqual(new Set(actual));
  });
});