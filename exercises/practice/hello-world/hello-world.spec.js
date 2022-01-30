import { compileWat } from './compile-wat';
import {TextDecoder} from 'util';

let wasmModule;
let currentInstance;
let linearMemory;
let textDecoder = new TextDecoder('utf8');

let buildHostString = jest.fn((offset, len) => {
  const buffer = new Uint8Array(linearMemory.buffer, offset, len);
  return textDecoder.decode(buffer);
});

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
      linearMemory = new WebAssembly.Memory({initial: 3});
      currentInstance = await WebAssembly.instantiate(wasmModule, {env: {linearMemory, buildHostString}});
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
    }
    done();
  });

  test('Say Hi!', () => {
    expect(currentInstance).toBeTruthy();
    currentInstance.exports.hello();
    expect(buildHostString.mock.calls.length).toBe(1);
    expect(buildHostString.mock.results[0].value).toBe("Hello, World!");
    expect(buildHostString.mock.calls[0][1]).toBe("Hello, World!".length);
  });
});
