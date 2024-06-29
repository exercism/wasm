import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./matching-brackets.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function isPaired(text) {
    const inputBufferOffset = 64;
    const inputBufferCapacity = 256;

    const inputLengthEncoded = new TextEncoder().encode(text).length;
    if (inputLengthEncoded > inputBufferCapacity) {
      throw new Error(
        `String is too large for buffer of size ${inputBufferCapacity} bytes`
      );
    }

    currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, text);

    return currentInstance.exports.isPaired(inputBufferOffset, text.length);
  }

describe("matching brackets", () => {
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

  test("paired square brackets", () => {
    console.log(isPaired("[]"));
    expect(isPaired("[]")).toBeTruthy();
  });

  xtest("empty string", () => {
    expect(isPaired("[]")).toBeTruthy();
  });

  xtest("unpaired brackets", () => {
    expect(isPaired("[[")).toBeFalsy();
  });

  xtest("wrong closing bracket", () => {
    expect(isPaired("{]")).toBeFalsy();
  });

  xtest("paired with whitespace", () => {
    expect(isPaired("{ }")).toBeTruthy();
  });

  xtest("partially paired brackets", () => {
    expect(isPaired("{[])")).toBeFalsy();
  });

  xtest("simple nested brackets", () => {
    expect(isPaired("{[]}")).toBeTruthy();
  });

  xtest("several paired brackets", () => {
    expect(isPaired("{}[]")).toBeTruthy();
  });

  xtest("paired and nested brackets", () => {
    expect(isPaired("([{}({}[])])")).toBeTruthy();
  });

  xtest("unopened closing brackets", () => {
    expect(isPaired("{[)][]}")).toBeFalsy();
  });

  xtest("paired and wrong nested brackets", () => {
    expect(isPaired("[({]})")).toBeFalsy();
  });

  xtest("paired and wrong nested brackets but innermost are correct", () => {
    expect(isPaired("[({}])")).toBeFalsy();
  });

  xtest("paired and incomplete brackets", () => {
    expect(isPaired("{}[")).toBeFalsy();
  });

  xtest("too many closing brackets", () => {
    expect(isPaired("[]]")).toBeFalsy();
  });

  xtest("early unexpected brackets", () => {
    expect(isPaired(")()")).toBeFalsy();
  });

  xtest("early mismatched brackets", () => {
    expect(isPaired("{)()")).toBeFalsy();
  });

  xtest("math expression", () => {
    expect(isPaired("(((185 + 223.85) * 15) - 543)/2")).toBeTruthy();
  });

  xtest("math expression", () => {
    expect(isPaired("\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)")).toBeTruthy();
  });
});
