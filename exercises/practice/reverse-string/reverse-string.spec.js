import { compileWat } from './compile-wat';
import {TextDecoder, TextEncoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');
let textEncoder = new TextEncoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("reverse-string.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

function reverseString(input){
  const inputOffset = 64;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  // Pass offset and length to WebAssembly function
  const [outputOffset, outputLength] = currentInstance.exports.reverseString(inputOffset, input.length);
  expect(outputLength).toEqual(input.length);

  // Decode JS string from returned offset and length
  const outputBuffer = new Uint8Array(linearMemory.buffer, outputOffset, outputLength);
  return textDecoder.decode(outputBuffer);
}

describe('ReverseString', () => {
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

  test('empty string', () => {
    expect(currentInstance).toBeTruthy();
    const expected = '';
    const actual = reverseString('');
    expect(actual).toEqual(expected);
  });

  xtest('a word', () => {
    const expected = 'tobor';
    const actual = reverseString('robot');
    expect(actual).toEqual(expected);
  });

  xtest('a capitalized word', () => {
    const expected = 'nemaR';
    const actual = reverseString('Ramen');
    expect(actual).toEqual(expected);
  });

  xtest('a sentence with punctuation', () => {
    const expected = '!yrgnuh ma I';
    const actual = reverseString('I am hungry!');
    expect(actual).toEqual(expected);
  });

  xtest('a palindrome', () => {
    const expected = 'racecar';
    const actual = reverseString('racecar');
    expect(actual).toEqual(expected);
  });

  xtest('an even-sized word', () => {
    const expected = 'reward';
    const actual = reverseString('drawer');
    expect(actual).toEqual(expected);
  });
});
