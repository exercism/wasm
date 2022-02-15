import { compileWat } from './compile-wat';
import {TextDecoder, TextEncoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');
let textEncoder = new TextEncoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("acronym.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

function parse(input){
  const inputOffset = 64;
  const inputBuffer = new Uint8Array(linearMemory.buffer, inputOffset, input.length);
  textEncoder.encodeInto(input, inputBuffer);

  // Pass offset and length to WebAssembly function
  const [outputOffset, outputLength] = currentInstance.exports.parse(inputOffset, input.length);

  // Decode JS string from returned offset and length
  const outputBuffer = new Uint8Array(linearMemory.buffer, outputOffset, outputLength);
  return textDecoder.decode(outputBuffer);
}

describe('Acronyms are produced from', () => {
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

  // basic
  test('title cased phrases', () => {
    expect(parse('Portable Network Graphics')).toEqual('PNG');
  });

  // lowercase words
  xtest('other title cased phrases', () => {
    expect(parse('Ruby on Rails')).toEqual('ROR');
  });

  // punctuation
  xtest('phrases with punctuation', () => {
    expect(parse('First In, First Out')).toEqual('FIFO');
  });

  // all caps word
  xtest('phrases with all uppercase words', () => {
    expect(parse('GNU Image Manipulation Program')).toEqual('GIMP');
  });

  // punctuation without whitespace
  xtest('phrases with punctuation without whitespace', () => {
    expect(parse('Complementary metal-oxide semiconductor')).toEqual('CMOS');
  });

  // very long abbreviation
  xtest('long phrases', () => {
    expect(
      parse(
        'Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me'
      )
    ).toEqual('ROTFLSHTMDCOALM');
  });

  // consecutive delimiters
  xtest('phrases with consecutive delimiters', () => {
    expect(parse('Something - I made up from thin air')).toEqual('SIMUFTA');
  });

  // apostrophes
  xtest('phrases with apostrophes', () => {
    expect(parse("Halley's Comet")).toEqual('HC');
  });

  // underscore emphasis
  xtest('phrases with underscore emphasis', () => {
    expect(parse('The Road _Not_ Taken')).toEqual('TRNT');
  });
});
