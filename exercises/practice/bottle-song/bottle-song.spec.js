import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./bottle-song.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function recite(startBottles, takeDown) {
  const [outputOffset, outputLength] = currentInstance.exports.recite(startBottles, takeDown);

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Bottle Song", () => {
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

  test("first generic verse", () => {
    const expected = [
      "Ten green bottles hanging on the wall,\n",
      "Ten green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be nine green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(10, 1);
    expect(actual).toEqual(expected);
  });

  xtest("last generic verse", () => {
    const expected = [
      "Three green bottles hanging on the wall,\n",
      "Three green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be two green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(3, 1);
    expect(actual).toEqual(expected);
  });

  xtest("verse with 2 bottles", () => {
    const expected = [
      "Two green bottles hanging on the wall,\n",
      "Two green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be one green bottle hanging on the wall.\n"
    ].join("");
    const actual = recite(2, 1);
    expect(actual).toEqual(expected);
  });

  xtest("verse with 1 bottle", () => {
    const expected = [
      "One green bottle hanging on the wall,\n",
      "One green bottle hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be no green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(1, 1);
    expect(actual).toEqual(expected);
  });

  xtest("first two verses", () => {
    const expected = [
      "Ten green bottles hanging on the wall,\n",
      "Ten green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be nine green bottles hanging on the wall.\n",
      "\n",
      "Nine green bottles hanging on the wall,\n",
      "Nine green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be eight green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(10, 2);
    expect(actual).toEqual(expected);
  });

  xtest("last three verses", () => {
    const expected = [
      "Three green bottles hanging on the wall,\n",
      "Three green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be two green bottles hanging on the wall.\n",
      "\n",
      "Two green bottles hanging on the wall,\n",
      "Two green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be one green bottle hanging on the wall.\n",
      "\n",
      "One green bottle hanging on the wall,\n",
      "One green bottle hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be no green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(3, 3);
    expect(actual).toEqual(expected);
  });

  xtest("all verses", () => {
    const expected = [
      "Ten green bottles hanging on the wall,\n",
      "Ten green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be nine green bottles hanging on the wall.\n",
      "\n",
      "Nine green bottles hanging on the wall,\n",
      "Nine green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be eight green bottles hanging on the wall.\n",
      "\n",
      "Eight green bottles hanging on the wall,\n",
      "Eight green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be seven green bottles hanging on the wall.\n",
      "\n",
      "Seven green bottles hanging on the wall,\n",
      "Seven green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be six green bottles hanging on the wall.\n",
      "\n",
      "Six green bottles hanging on the wall,\n",
      "Six green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be five green bottles hanging on the wall.\n",
      "\n",
      "Five green bottles hanging on the wall,\n",
      "Five green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be four green bottles hanging on the wall.\n",
      "\n",
      "Four green bottles hanging on the wall,\n",
      "Four green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be three green bottles hanging on the wall.\n",
      "\n",
      "Three green bottles hanging on the wall,\n",
      "Three green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be two green bottles hanging on the wall.\n",
      "\n",
      "Two green bottles hanging on the wall,\n",
      "Two green bottles hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be one green bottle hanging on the wall.\n",
      "\n",
      "One green bottle hanging on the wall,\n",
      "One green bottle hanging on the wall,\n",
      "And if one green bottle should accidentally fall,\n",
      "There'll be no green bottles hanging on the wall.\n"
    ].join("");
    const actual = recite(10, 10);
    expect(actual).toEqual(expected);
  });
});
