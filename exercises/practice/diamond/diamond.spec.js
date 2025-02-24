import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./diamond.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const rows = (letter) => {
  const [outputOffset, outputLength] = currentInstance.exports.rows(letter.charCodeAt(0));
  const output = currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  return output ? output.split('\n').slice(0, -1) : []
}

describe('Diamond', () => {
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
  test("Degenerate case with a single 'A' row", () => {
    expect(rows('A')).toEqual(['A']);
  });

  xtest('Degenerate case with no row containing 3 distinct groups of spaces', () => {
    // prettier-ignore
    expect(rows('B')).toEqual([
      ' A ',
      'B B',
      ' A '
    ]);
  });

  xtest('Smallest non-degenerate case with odd diamond side length', () => {
    // prettier-ignore
    expect(rows('C')).toEqual([
      '  A  ',
      ' B B ',
      'C   C',
      ' B B ',
      '  A  '
    ]);
  });

  xtest('Smallest non-degenerate case with even diamond side length', () => {
    expect(rows('D')).toEqual([
      '   A   ',
      '  B B  ',
      ' C   C ',
      'D     D',
      ' C   C ',
      '  B B  ',
      '   A   ',
    ]);
  });

  xtest('Largest possible diamond', () => {
    expect(rows('Z')).toEqual([
      '                         A                         ',
      '                        B B                        ',
      '                       C   C                       ',
      '                      D     D                      ',
      '                     E       E                     ',
      '                    F         F                    ',
      '                   G           G                   ',
      '                  H             H                  ',
      '                 I               I                 ',
      '                J                 J                ',
      '               K                   K               ',
      '              L                     L              ',
      '             M                       M             ',
      '            N                         N            ',
      '           O                           O           ',
      '          P                             P          ',
      '         Q                               Q         ',
      '        R                                 R        ',
      '       S                                   S       ',
      '      T                                     T      ',
      '     U                                       U     ',
      '    V                                         V    ',
      '   W                                           W   ',
      '  X                                             X  ',
      ' Y                                               Y ',
      'Z                                                 Z',
      ' Y                                               Y ',
      '  X                                             X  ',
      '   W                                           W   ',
      '    V                                         V    ',
      '     U                                       U     ',
      '      T                                     T      ',
      '       S                                   S       ',
      '        R                                 R        ',
      '         Q                               Q         ',
      '          P                             P          ',
      '           O                           O           ',
      '            N                         N            ',
      '             M                       M             ',
      '              L                     L              ',
      '               K                   K               ',
      '                J                 J                ',
      '                 I               I                 ',
      '                  H             H                  ',
      '                   G           G                   ',
      '                    F         F                    ',
      '                     E       E                     ',
      '                      D     D                      ',
      '                       C   C                       ',
      '                        B B                        ',
      '                         A                         ',
    ]);
  });
});