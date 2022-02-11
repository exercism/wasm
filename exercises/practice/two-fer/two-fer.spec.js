import { compileWat } from './compile-wat';
import {TextDecoder, TextEncoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');
let textEncoder = new TextEncoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("two-fer.wat", {multi_value: true, bulk_memory: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

function twoFer(input = ""){
  const inputOffset = 64;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  // Pass offset and length to WebAssembly function
  const [outputOffset, outputLength] = currentInstance.exports.twoFer(inputOffset, input.length);

  // Decode JS string from returned offset and length
  const outputBuffer = new Uint8Array(linearMemory.buffer, outputOffset, outputLength);
  return textDecoder.decode(outputBuffer);
}

describe('twoFer()', () => {
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

  test('no name given', () => {
    expect(twoFer()).toEqual('One for you, one for me.');
  });

  xtest('a name given', () => {
    expect(twoFer('Alice')).toEqual('One for Alice, one for me.');
  });

  xtest('another name given', () => {
    expect(twoFer('Bob')).toEqual('One for Bob, one for me.');
  });
});
