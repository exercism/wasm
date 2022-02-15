import { compileWat } from './compile-wat';
import {TextEncoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textEncoder = new TextEncoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("nucleotide-count.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
    process.exit(1);
  }
});

function countNucleotides(input){
  const inputOffset = 64;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  // Pass offset and length to WebAssembly function
  return currentInstance.exports.countNucleotides(inputOffset, input.length);
}


describe('count all nucleotides in a strand', () => {
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

  test('empty strand', () => {
    expect(countNucleotides('')).toEqual([0, 0, 0, 0]);
  });

  xtest('can count one nucleotide in single-character input', () => {
    expect(countNucleotides('G')).toEqual([0, 0, 1, 0]);
  });

  xtest('strand with repeated nucleotide', () => {
    expect(countNucleotides('GGGGGGG')).toEqual([0, 0, 7, 0]);
  });

  xtest('strand with multiple nucleotides', () => {
    expect(
      countNucleotides(
        'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
      )
    ).toEqual([20, 12, 17, 21]);
  });

  xtest('strand with invalid nucleotides', () => {
    expect(countNucleotides('AGXXACT')).toEqual([-1, -1, -1, -1]);
  });
});
