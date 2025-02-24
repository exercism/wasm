import { test as xtest } from '@jest/globals';
import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./.meta/proof.ci.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const commands = (number) => {
  const [outputOffset, outputLength] = currentInstance.exports.commands(number);
  const output = currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  return output ? output.split(',') : [];
}

describe('Secret Handshake', () => {
  beforeEach(async () => {
    currentInstance = null;
    if (!wasmModule) {
      return Promise.reject();
    }
    try {
      currentInstance = await new WasmRunner(wasmModule);
      return Promise.resolve();
    } catch (err) {
      console.log(`Error instantiating WebAssembly module: ${err}`);
      return Promise.reject();
    }
  });
  describe('Create A Handshake For A Number', () => {
    test('wink for 1', () => {
      expect(commands(1)).toEqual(['wink']);
    });

    xtest('double blink for 10', () => {
      expect(commands(2)).toEqual(['double blink']);
    });

    xtest('close your eyes for 100', () => {
      expect(commands(4)).toEqual(['close your eyes']);
    });

    xtest('jump for 1000', () => {
      expect(commands(8)).toEqual(['jump']);
    });

    xtest('combine two actions', () => {
      expect(commands(3)).toEqual(['wink', 'double blink']);
    });

    xtest('reverse two actions', () => {
      expect(commands(19)).toEqual(['double blink', 'wink']);
    });

    xtest('reversing one action gives the same action', () => {
      expect(commands(24)).toEqual(['jump']);
    });

    xtest('reversing no actions still gives no actions', () => {
      expect(commands(16)).toEqual([]);
    });

    xtest('all possible actions', () => {
      expect(commands(15)).toEqual([
        'wink',
        'double blink',
        'close your eyes',
        'jump',
      ]);
    });

    xtest('reverse all possible actions', () => {
      expect(commands(31)).toEqual([
        'jump',
        'close your eyes',
        'double blink',
        'wink',
      ]);
    });

    xtest('do nothing for zero', () => {
      expect(commands(0)).toEqual([]);
    });
  });
});