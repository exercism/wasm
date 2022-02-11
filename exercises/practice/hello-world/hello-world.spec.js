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

  test('Say Hi!', () => {
    expect(currentInstance).toBeTruthy();
    const [offset, length] = currentInstance.exports.hello();
    expect(length).toBe(13);
    const buffer = new Uint8Array(linearMemory.buffer, offset, length);
    const greeting = textDecoder.decode(buffer);
    expect(greeting).toBe("Hello, World!");
  });
});
