import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./proverb.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function recite(strings) {
  const inputBufferOffset = 128;
  const inputBufferCapacity = 256;

  const inputLengthEncoded = new TextEncoder().encode(strings).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, strings);

  const [outputOffset, outputLength] = currentInstance.exports.recite(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Proverb", () => {
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

  test("zero pieces", () => {
    const strings = [
    ].join("");
    const expected = [
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });

  xtest("one piece", () => {
    const strings = [
      "nail\n"
    ].join("");
    const expected = [
      "And all for the want of a nail.\n"
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });

  xtest("two pieces", () => {
    const strings = [
      "nail\n",
      "shoe\n"
    ].join("");
    const expected = [
      "For want of a nail the shoe was lost.\n",
      "And all for the want of a nail.\n"
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });

  xtest("three pieces", () => {
    const strings = [
      "nail\n",
      "shoe\n",
      "horse\n"
    ].join("");
    const expected = [
      "For want of a nail the shoe was lost.\n",
      "For want of a shoe the horse was lost.\n",
      "And all for the want of a nail.\n"
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });

  xtest("full proverb", () => {
    const strings = [
      "nail\n",
      "shoe\n",
      "horse\n",
      "rider\n",
      "message\n",
      "battle\n",
      "kingdom\n"
    ].join("");
    const expected = [
      "For want of a nail the shoe was lost.\n",
      "For want of a shoe the horse was lost.\n",
      "For want of a horse the rider was lost.\n",
      "For want of a rider the message was lost.\n",
      "For want of a message the battle was lost.\n",
      "For want of a battle the kingdom was lost.\n",
      "And all for the want of a nail.\n"
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });

  xtest("four pieces modernized", () => {
    const strings = [
      "pin\n",
      "gun\n",
      "soldier\n",
      "battle\n"
    ].join("");
    const expected = [
      "For want of a pin the gun was lost.\n",
      "For want of a gun the soldier was lost.\n",
      "For want of a soldier the battle was lost.\n",
      "And all for the want of a pin.\n"
    ].join("");
    const actual = recite(strings);
    expect(actual).toEqual(expected);
  });
});
