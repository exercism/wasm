import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./space-age.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

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

function age(planet, seconds) {
    return currentInstance.exports.age(currentInstance.exports[planet], seconds);
}

describe('Space Age', () => {
  test('age on Earth', () => {
    expect(age('earth', 1000000000)).toEqual(31.69);
  });

  xtest('age on Mercury', () => {
    expect(age('mercury', 2134835688)).toEqual(280.88);
  });

  xtest('age on Venus', () => {
    expect(age('venus', 189839836)).toEqual(9.78);
  });

  xtest('age on Mars', () => {
    expect(age('mars', 2129871239)).toEqual(35.88);
  });

  xtest('age on Jupiter', () => {
    expect(age('jupiter', 901876382)).toEqual(2.41);
  });

  xtest('age on Saturn', () => {
    expect(age('saturn', 2000000000)).toEqual(2.15);
  });

  xtest('age on Uranus', () => {
    expect(age('uranus', 1210123456)).toEqual(0.46);
  });

  xtest('age on Neptune', () => {
    expect(age('neptune', 1821023456)).toEqual(0.35);
  });
});