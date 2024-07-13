import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./minesweeper.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function annotate(input) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(input).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, input);

  // Pass offset and length to WebAssembly function
  const [outputOffset, outputLength] = currentInstance.exports.annotate(
    inputBufferOffset,
    inputLengthEncoded
  );
  expect(outputLength).toEqual(inputLengthEncoded);

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("annotate()", () => {
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

  test("no rows", () => {
    const minefield = [
      ""
    ].join("\n");
    const expected = [
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("no columns", () => {
    const minefield = [
      "",
      ""
    ].join("\n");
    const expected = [
      "",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("no mines", () => {
    const minefield = [
      "   ",
      "   ",
      "   ",
      ""
    ].join("\n");
    const expected = [
      "   ",
      "   ",
      "   ",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("minefield with only mines", () => {
    const minefield = [
      "***",
      "***",
      "***",
      ""
    ].join("\n");
    const expected = [
      "***",
      "***",
      "***",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("mine surrounded by spaces", () => {
    const minefield = [
      "   ",
      " * ",
      "   ",
      ""
    ].join("\n");
    const expected = [
      "111",
      "1*1",
      "111",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("space surrounded by mines", () => {
    const minefield = [
      "***",
      "* *",
      "***",
      ""
    ].join("\n");
    const expected = [
      "***",
      "*8*",
      "***",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("horizontal line", () => {
    const minefield = [
      " * * ",
      ""
    ].join("\n");
    const expected = [
      "1*2*1",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("horizontal line, mines at edges", () => {
    const minefield = [
      "*   *",
      ""
    ].join("\n");
    const expected = [
      "*1 1*",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("vertical line", () => {
    const minefield = [
      " ",
      "*",
      " ",
      "*",
      " ",
      ""
    ].join("\n");
    const expected = [
      "1",
      "*",
      "2",
      "*",
      "1",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("vertical line, mines at edges", () => {
    const minefield = [
      "*",
      " ",
      " ",
      " ",
      "*",
      ""
    ].join("\n");
    const expected = [
      "*",
      "1",
      " ",
      "1",
      "*",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("cross", () => {
    const minefield = [
      "  *  ",
      "  *  ",
      "*****",
      "  *  ",
      "  *  ",
      ""
    ].join("\n");
    const expected = [
      " 2*2 ",
      "25*52",
      "*****",
      "25*52",
      " 2*2 ",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });

  xtest("large minefield", () => {
    const minefield = [
      " *  * ",
      "  *   ",
      "    * ",
      "   * *",
      " *  * ",
      "      ",
      ""
    ].join("\n");
    const expected = [
      "1*22*1",
      "12*322",
      " 123*2",
      "112*4*",
      "1*22*2",
      "111111",
      ""
    ].join("\n");
    const actual = annotate(minefield);
    expect(actual).toEqual(expected);
  });
});
