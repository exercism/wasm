import { compileWat } from './compile-wat';
import {TextDecoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');

beforeAll(async () => {
  try {
    const {buffer} = await compileWat("hello-world.wat", {multi_value: true});
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
  }
});

describe('Hello World', () => {
  beforeEach(async (done) => {
    currentInstance = null;

    if (!wasmModule) {
      done();
      return;
    }
    try {
      linearMemory = new WebAssembly.Memory({initial: 1});
      currentInstance = await WebAssembly.instantiate(wasmModule, {env: {linearMemory}});
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
    }
    done();
  });

  test('Say Hi!', () => {
    expect(currentInstance).toBeTruthy();
    const offset = currentInstance.exports.hello();
    const maxBuffer = 20;
    const buffer = new Uint8Array(linearMemory.buffer, offset, maxBuffer);
    const greetingBuffer = textDecoder.decode(buffer);
    const greeting = greetingBuffer.split("\0")[0];
    expect(greeting).toBe("Hello, World!");
  });
});
