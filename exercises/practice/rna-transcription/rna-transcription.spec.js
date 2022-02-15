import { compileWat } from './compile-wat';
import {TextDecoder, TextEncoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');
let textEncoder = new TextEncoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("rna-transcription.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
    process.exit(1);
  }
});

function toRna(input){
  const inputOffset = 64;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  // Pass offset and length to WebAssembly function
  const [outputOffset, outputLength] = currentInstance.exports.toRna(inputOffset, input.length);
  expect(outputLength).toEqual(input.length);

  // Decode JS string from returned offset and length
  const outputBuffer = new Uint8Array(linearMemory.buffer, outputOffset, outputLength);
  return textDecoder.decode(outputBuffer);
}

describe('Transcription', () => {
  beforeEach(async () => {
    currentInstance = null;
    if (!wasmModule) {
      return Promise.reject();
    }
    try {
      linearMemory = new WebAssembly.Memory({initial: 1});
      currentInstance = await WebAssembly.instantiate(wasmModule, {env: {linearMemory}});
      return Promise.resolve();
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
      return Promise.reject();
    }
  });

  test('empty rna sequence', () => {
    expect(toRna('')).toEqual('');
  });

  xtest('transcribes cytosine to guanine', () => {
    expect(toRna('C')).toEqual('G');
  });

  xtest('transcribes guanine to cytosine', () => {
    expect(toRna('G')).toEqual('C');
  });

  xtest('transcribes thymine to adenine', () => {
    expect(toRna('T')).toEqual('A');
  });

  xtest('transcribes adenine to uracil', () => {
    expect(toRna('A')).toEqual('U');
  });

  xtest('transcribes all dna nucleotides to their rna complements', () => {
    expect(toRna('ACGTGGTCTTAA')).toEqual('UGCACCAGAAUU');
  });
});
