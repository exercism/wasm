import { compileWat } from './compile-wat';
import {TextEncoder, TextDecoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textEncoder = new TextEncoder('utf8');
let textDecoder = new TextDecoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("resistor-color.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

function logMem(offset, length) {
  const outputBuffer = new Uint8Array(linearMemory.buffer, offset, length);
  const str = textDecoder.decode(outputBuffer);
  console.log(`"${str}"`);
}

function logInteger(num) {
  console.log(`"${num}"`);
}

function colorCode(input = ""){
  const inputOffset = 48;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  return currentInstance.exports.colorCode(inputOffset, input.length);
}

describe('ResistorColor', () => {
  beforeEach(async () => {
    currentInstance = null;

    if (!wasmModule) {
      return Promise.reject();
    }
    try {
      linearMemory = new WebAssembly.Memory({initial: 1});
      currentInstance = await WebAssembly.instantiate(wasmModule, {env: {linearMemory, logMem, logInteger}});
      return Promise.resolve();
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
      return Promise.reject();
    }
  });

  describe('Color codes', () => {
    xtest('Black', () => {
      expect(colorCode('black')).toEqual(0);
    });

    xtest('White', () => {
      expect(colorCode('white')).toEqual(9);
    });

    xtest('Orange', () => {
      expect(colorCode('orange')).toEqual(3);
    });
  });

  test('Colors', () => {
    const [offset, length] = currentInstance.exports.colors();

    // Decode JS string from returned offset and length
    const outputBuffer = new Uint8Array(linearMemory.buffer, offset, length);
    const commaDelimited = textDecoder.decode(outputBuffer);
    const colors = commaDelimited.split(",");

    expect(colors).toEqual([
      'black',
      'brown',
      'red',
      'orange',
      'yellow',
      'green',
      'blue',
      'violet',
      'grey',
      'white',
    ]);
  });
});
