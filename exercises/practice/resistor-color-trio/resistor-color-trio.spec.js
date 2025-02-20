import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./resistor-color-trio.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

class ResistorColorTrio {
    constructor([first, second, third]) {
        console.log(first, second, third);
        const firstBufferOffset = 1024;
        const firstBufferCapacity = 1024;

        const firstLengthEncoded = new TextEncoder().encode(first).length;
        if (firstLengthEncoded > firstBufferCapacity) {
            throw new Error(
            `String is too large for buffer of size ${firstBufferCapacity} bytes`
            );
        }

        currentInstance.set_mem_as_utf8(firstBufferOffset, firstLengthEncoded, first);

        const secondBufferOffset = 2048;
        const secondBufferCapacity = 1024;

        const secondLengthEncoded = new TextEncoder().encode(second).length;
        if (secondLengthEncoded > secondBufferCapacity) {
            throw new Error(
            `String is too large for buffer of size ${secondBufferCapacity} bytes`
            );
        }

        currentInstance.set_mem_as_utf8(secondBufferOffset, secondLengthEncoded, second);

        const thirdBufferOffset = 3072;
        const thirdBufferCapacity = 1024;

        const thirdLengthEncoded = new TextEncoder().encode(third).length;
        if (thirdLengthEncoded > thirdBufferCapacity) {
            throw new Error(
            `String is too large for buffer of size ${thirdBufferCapacity} bytes`
            );
        }

        currentInstance.set_mem_as_utf8(thirdBufferOffset, thirdLengthEncoded, third);

        const [outputOffset, outputLength] = currentInstance.exports.value(
            firstBufferOffset,
            firstLengthEncoded,
            secondBufferOffset,
            secondLengthEncoded,
            thirdBufferOffset,
            thirdLengthEncoded
        );

        const value = currentInstance.get_mem_as_utf8(outputOffset, outputLength);

        if (!value) throw new Error('invalid color');

        this.label = `Resistor value: ${value}`;
    }
}

function makeLabel({ value, unit }) {
  return `Resistor value: ${value} ${unit}`;
}

describe('Resistor Color Trio', () => {
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
  test('Orange and orange and black', () => {
    expect(new ResistorColorTrio(['orange', 'orange', 'black']).label).toEqual(
      makeLabel({ value: 33, unit: 'ohms' }),
    );
  });

  xtest('Blue and grey and brown', () => {
    expect(new ResistorColorTrio(['blue', 'grey', 'brown']).label).toEqual(
      makeLabel({ value: 680, unit: 'ohms' }),
    );
  });

  xtest('Red and black and red', () => {
    expect(new ResistorColorTrio(['red', 'black', 'red']).label).toEqual(
      makeLabel({ value: 2, unit: 'kiloohms' }),
    );
  });

  xtest('Green and brown and orange', () => {
    expect(new ResistorColorTrio(['green', 'brown', 'orange']).label).toEqual(
      makeLabel({ value: 51, unit: 'kiloohms' }),
    );
  });

  xtest('Yellow and violet and yellow', () => {
    expect(new ResistorColorTrio(['yellow', 'violet', 'yellow']).label).toEqual(
      makeLabel({ value: 470, unit: 'kiloohms' }),
    );
  });

  // optional: error
  xtest('Invalid color', () => {
    expect(
      () => new ResistorColorTrio(['yellow', 'purple', 'black']).label,
    ).toThrow(/invalid color/);
  });
});