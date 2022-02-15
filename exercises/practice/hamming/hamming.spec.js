import { compileWat } from './compile-wat';
import {TextEncoder} from 'util';
import { exit } from 'process';

let wasmModule;
let currentInstance;
let linearMemory;
let textEncoder = new TextEncoder('utf8');

function compute(first, second){
  const firstOffset = 1024;
  const firstBuffer = new Uint8Array(linearMemory.buffer, firstOffset, first.length);
  textEncoder.encodeInto(first, firstBuffer);
  
  const secondOffset = 2048;
  const secondBuffer = new Uint8Array(linearMemory.buffer, secondOffset, second.length);
  textEncoder.encodeInto(second, secondBuffer);

  return currentInstance.exports.compute(firstOffset, first.length, secondOffset, second.length);

}

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("hamming.wat");
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
    exit(1);
  }
});

describe('Hamming', () => {
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

  test('empty strands', () => {
    expect(compute('', '')).toEqual(0);
  });

  xtest('single letter identical strands', () => {
    expect(compute('A', 'A')).toEqual(0);
  });

  xtest('single letter different strands', () => {
    expect(compute('G', 'T')).toEqual(1);
  });

  xtest('long identical strands', () => {
    expect(compute('GGACTGAAATCTG', 'GGACTGAAATCTG')).toEqual(0);
  });

  xtest('long different strands', () => {
    expect(compute('GGACGGATTCTG', 'AGGACGGATTCT')).toEqual(9);
  });

  xtest('disallow first strand longer', () => {
    expect(compute('AATG', 'AAA')).toEqual(-1);
  });

  xtest('disallow second strand longer', () => {
    expect(compute('ATA', 'AGTG')).toEqual(-1);
  });

  xtest('disallow empty first strand', () => {
    expect(compute('', 'G')).toEqual(-1);
  });

  xtest('disallow empty second strand', () => {
    expect(compute('G', '')).toEqual(-1);
  });
});
