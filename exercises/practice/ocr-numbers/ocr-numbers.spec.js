import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./ocr-numbers.wat", import.meta.url);
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

function convert(input) {
    const inputBufferOffset = 64;
    const inputBufferCapacity = 128;

    const inputLengthEncoded = new TextEncoder().encode(input).length;
    if (inputLengthEncoded > inputBufferCapacity) {
        throw new Error(
        `String is too large for buffer of size ${inputBufferCapacity} bytes`
        );
    }

    currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

    // Pass offset and length to WebAssembly function
    const [outputOffset, outputLength] = currentInstance.exports.convert(
        inputBufferOffset,
        input.length
    );

    // Decode JS string from returned offset and length
    return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe('ocr', () => {
  test('recognizes zero', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '| |\n' +
        '|_|\n' +
        '   '
      ),
    ).toBe('0');
  });

  xtest('recognizes one', () => {
    expect(
      // prettier-ignore
      convert(
        '   \n' +
        '  |\n' +
        '  |\n' +
        '   '
      ),
    ).toBe('1');
  });

  xtest('recognizes two', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        ' _|\n' +
        '|_ \n' +
        '   '
      ),
    ).toBe('2');
  });

  xtest('recognizes three', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        ' _|\n' +
        ' _|\n' +
        '   '
      ),
    ).toBe('3');
  });

  xtest('recognizes four', () => {
    expect(
      // prettier-ignore
      convert(
        '   \n' +
        '|_|\n' +
        '  |\n' +
        '   '
      ),
    ).toBe('4');
  });

  xtest('recognizes five', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '|_ \n' +
        ' _|\n' +
        '   '
      ),
    ).toBe('5');
  });

  xtest('recognizes six', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '|_ \n' +
        '|_|\n' +
        '   '
      ),
    ).toBe('6');
  });

  xtest('recognizes seven', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '  |\n' +
        '  |\n' +
        '   '
      ),
    ).toBe('7');
  });

  xtest('recognizes eight', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '|_|\n' +
        '|_|\n' +
        '   '
      ),
    ).toBe('8');
  });

  xtest('recognizes nine', () => {
    expect(
      // prettier-ignore
      convert(
        ' _ \n' +
        '|_|\n' +
        ' _|\n' +
        '   '
      ),
    ).toBe('9');
  });

  xtest('recognizes ten', () => {
    expect(
      // prettier-ignore
      convert(
        '    _ \n' +
        '  || |\n' +
        '  ||_|\n' +
        '      '
      ),
    ).toBe('10');
  });

  xtest('identifies garble', () => {
    expect(
      // prettier-ignore
      convert(
        '   \n' +
        '| |\n' +
        '| |\n' +
        '   '
      ),
    ).toBe('?');
  });

  xtest('converts 110101100', () => {
    expect(
      // prettier-ignore
      convert(
        '       _     _        _  _ \n' +
        '  |  || |  || |  |  || || |\n' +
        '  |  ||_|  ||_|  |  ||_||_|\n' +
        '                           '
      ),
    ).toBe('110101100');
  });

  xtest('identifies garble mixed in', () => {
    expect(
      // prettier-ignore
      convert(
        '       _     _           _ \n' +
        '  |  || |  || |     || || |\n' +
        '  |  | _|  ||_|  |  ||_||_|\n' +
        '                           '
      ),
    ).toBe('11?10?1?0');
  });

  xtest('converts 1234567890', () => {
    expect(
      // prettier-ignore
      convert(
        '    _  _     _  _  _  _  _  _ \n' +
        '  | _| _||_||_ |_   ||_||_|| |\n' +
        '  ||_  _|  | _||_|  ||_| _||_|\n' +
        '                              '
      ),
    ).toBe('1234567890');
  });

  xtest('converts 123 456 789', () => {
    expect(
      // prettier-ignore
      convert(
        '    _  _ \n' +
        '  | _| _|\n' +
        '  ||_  _|\n' +
        '         \n' +
        '    _  _ \n' +
        '|_||_ |_ \n' +
        '  | _||_|\n' +
        '         \n' +
        ' _  _  _ \n' +
        '  ||_||_|\n' +
        '  ||_| _|\n' +
        '         '
      ),
    ).toBe('123,456,789');
  });
});