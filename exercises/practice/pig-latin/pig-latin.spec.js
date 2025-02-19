import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./pig-latin.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const translate = (text) => {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(text).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, text);

  const [outputOffset, outputLength] = currentInstance.exports.translate(
    inputBufferOffset,
    inputLengthEncoded
  );

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe('Pig Latin', () => {
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

  describe('ay is added to words that start with vowels', () => {
    test('word beginning with a', () => {
      expect(translate('apple')).toEqual('appleay');
    });

    xtest('word beginning with e', () => {
      expect(translate('ear')).toEqual('earay');
    });

    xtest('word beginning with i', () => {
      expect(translate('igloo')).toEqual('iglooay');
    });

    xtest('word beginning with o', () => {
      expect(translate('object')).toEqual('objectay');
    });

    xtest('word beginning with u', () => {
      expect(translate('under')).toEqual('underay');
    });

    xtest('word beginning with a vowel and followed by a qu', () => {
      expect(translate('equal')).toEqual('equalay');
    });
  });

  describe('first letter and ay are moved to the end of words that start with consonants', () => {
    xtest('word beginning with p', () => {
      expect(translate('pig')).toEqual('igpay');
    });

    xtest('word beginning with k', () => {
      expect(translate('koala')).toEqual('oalakay');
    });

    xtest('word beginning with x', () => {
      expect(translate('xenon')).toEqual('enonxay');
    });

    xtest('word beginning with q without a following u', () => {
      expect(translate('qat')).toEqual('atqay');
    });
  });

  describe('some letter clusters are treated like a single consonant', () => {
    xtest('word beginning with ch', () => {
      expect(translate('chair')).toEqual('airchay');
    });

    xtest('word beginning with qu', () => {
      expect(translate('queen')).toEqual('eenquay');
    });

    xtest('word beginning with qu and a preceding consonant', () => {
      expect(translate('square')).toEqual('aresquay');
    });

    xtest('word beginning with th', () => {
      expect(translate('therapy')).toEqual('erapythay');
    });

    xtest('word beginning with thr', () => {
      expect(translate('thrush')).toEqual('ushthray');
    });

    xtest('word beginning with sch', () => {
      expect(translate('school')).toEqual('oolschay');
    });
  });

  describe('some letter clusters are treated like a single vowel', () => {
    xtest('word beginning with yt', () => {
      expect(translate('yttria')).toEqual('yttriaay');
    });

    xtest('word beginning with xr', () => {
      expect(translate('xray')).toEqual('xrayay');
    });
  });

  describe('position of y in a word determines if it is a consonant or a vowel', () => {
    xtest('y is treated like a consonant at the beginning of a word', () => {
      expect(translate('yellow')).toEqual('ellowyay');
    });

    xtest('y is treated like a vowel at the end of a consonant cluster', () => {
      expect(translate('rhythm')).toEqual('ythmrhay');
    });

    xtest('y as second letter in two letter word', () => {
      expect(translate('my')).toEqual('ymay');
    });
  });

  describe('phrases are translated', () => {
    xtest('a whole phrase', () => {
      expect(translate('quick fast run')).toEqual('ickquay astfay unray');
    });
  });
});