import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./protein-translation.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const translate = (input = "") => {
  const inputBufferOffset = 1024;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  const [outputOffset, outputLength] = currentInstance.exports.translate(
    inputBufferOffset,
    inputLengthEncoded
  );
  if (outputOffset == -1)
    throw new Error('Invalid codon');
  const output = currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  
  return output ? output.split("\n").filter(Boolean) : [];
}

describe('ProteinTranslation', () => {
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

  xtest('Empty RNA has no proteins', () => {
    expect(translate()).toEqual([]);
  });

  describe('Single codons', () => {
    const mapping = [
      ['Methionine', ['AUG']],
      ['Phenylalanine', ['UUU', 'UUC']],
      ['Leucine', ['UUA', 'UUG']],
      ['Serine', ['UCU', 'UCC', 'UCA', 'UCG']],
      ['Tyrosine', ['UAU', 'UAC']],
      ['Cysteine', ['UGU', 'UGC']],
      ['Tryptophan', ['UGG']],
    ];

    mapping.forEach(([protein, codons]) => {
      codons.forEach((codon, index) => {
        const seq = index + 1;
        xtest(`${protein} RNA sequence ${seq} translates into ${protein}`, () => {
          expect(translate(codon)).toEqual([protein]);
        });
      });
    });

    const stopCodons = ['UAA', 'UAG', 'UGA'];

    stopCodons.forEach((codon, index) => {
      xtest(`STOP codon RNA sequence ${index + 1}`, () => {
        expect(translate(codon)).toEqual([]);
      });
    });
  });

  describe('Multiple codons', () => {
    xtest('Sequence of two protein codons translates into proteins', () => {
      expect(translate('UUUUUU')).toEqual(['Phenylalanine', 'Phenylalanine']);
    });

    test('Sequence of two different protein codons translates into proteins', () => {
      expect(translate('UUAUUG')).toEqual(['Leucine', 'Leucine']);
    });

    xtest('Translate RNA strand into correct protein list', () => {
      expect(translate('AUGUUUUGG')).toEqual([
        'Methionine',
        'Phenylalanine',
        'Tryptophan',
      ]);
    });

    xtest('Translation stops if STOP codon at beginning of sequence', () => {
      expect(translate('UAGUGG')).toEqual([]);
    });

    xtest('Translation stops if STOP codon at end of three-codon sequence', () => {
      expect(translate('AUGUUUUAA')).toEqual(['Methionine', 'Phenylalanine']);
    });

    xtest('Translation stops if STOP codon in middle of three-codon sequence', () => {
      expect(translate('UGGUAGUGG')).toEqual(['Tryptophan']);
    });

    xtest('Translation stops if STOP codon in middle of six-codon sequence', () => {
      expect(translate('UGGUGUUAUUAAUGGUUU')).toEqual([
        'Tryptophan',
        'Cysteine',
        'Tyrosine',
      ]);
    });
  });

  describe('Unexpected strands', () => {
    xtest("Non-existing codon can't translate", () => {
      expect(() => translate('AAA')).toThrow(new Error('Invalid codon'));
    });

    xtest("Unknown amino acids, not part of a codon, can't translate", () => {
      expect(() => translate('XYZ')).toThrow(new Error('Invalid codon'));
    });

    xtest("Incomplete RNA sequence can't translate", () => {
      expect(() => translate('AUGU')).toThrow(new Error('Invalid codon'));
    });

    xtest('Incomplete RNA sequence can translate if valid until a STOP codon', () => {
      expect(translate('UUCUUCUAAUGGU')).toEqual([
        'Phenylalanine',
        'Phenylalanine',
      ]);
    });
  });
});