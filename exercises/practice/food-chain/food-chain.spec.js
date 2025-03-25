import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./food-chain.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function recite(startVerse, endVerse) {
  const [outputOffset, outputLength] = currentInstance.exports.recite(startVerse, endVerse);

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Food Chain", () => {
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

  test("fly", () => {
    const expected = [
      "I know an old lady who swallowed a fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(1, 1);
    expect(actual).toEqual(expected);
  });

  xtest("spider", () => {
    const expected = [
      "I know an old lady who swallowed a spider.\n",
      "It wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(2, 2);
    expect(actual).toEqual(expected);
  });

  xtest("bird", () => {
    const expected = [
      "I know an old lady who swallowed a bird.\n",
      "How absurd to swallow a bird!\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(3, 3);
    expect(actual).toEqual(expected);
  });

  xtest("cat", () => {
    const expected = [
      "I know an old lady who swallowed a cat.\n",
      "Imagine that, to swallow a cat!\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(4, 4);
    expect(actual).toEqual(expected);
  });

  xtest("dog", () => {
    const expected = [
      "I know an old lady who swallowed a dog.\n",
      "What a hog, to swallow a dog!\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(5, 5);
    expect(actual).toEqual(expected);
  });

  xtest("goat", () => {
    const expected = [
      "I know an old lady who swallowed a goat.\n",
      "Just opened her throat and swallowed a goat!\n",
      "She swallowed the goat to catch the dog.\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(6, 6);
    expect(actual).toEqual(expected);
  });

  xtest("cow", () => {
    const expected = [
      "I know an old lady who swallowed a cow.\n",
      "I don't know how she swallowed a cow!\n",
      "She swallowed the cow to catch the goat.\n",
      "She swallowed the goat to catch the dog.\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(7, 7);
    expect(actual).toEqual(expected);
  });

  xtest("horse", () => {
    const expected = [
      "I know an old lady who swallowed a horse.\n",
      "She's dead, of course!\n"
    ].join("");
    const actual = recite(8, 8);
    expect(actual).toEqual(expected);
  });

  xtest("multiple verses", () => {
    const expected = [
      "I know an old lady who swallowed a fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a spider.\n",
      "It wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a bird.\n",
      "How absurd to swallow a bird!\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ].join("");
    const actual = recite(1, 3);
    expect(actual).toEqual(expected);
  });

  xtest("full song", () => {
    const expected = [
      "I know an old lady who swallowed a fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a spider.\n",
      "It wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a bird.\n",
      "How absurd to swallow a bird!\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a cat.\n",
      "Imagine that, to swallow a cat!\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a dog.\n",
      "What a hog, to swallow a dog!\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a goat.\n",
      "Just opened her throat and swallowed a goat!\n",
      "She swallowed the goat to catch the dog.\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a cow.\n",
      "I don't know how she swallowed a cow!\n",
      "She swallowed the cow to catch the goat.\n",
      "She swallowed the goat to catch the dog.\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n",
      "\n",
      "I know an old lady who swallowed a horse.\n",
      "She's dead, of course!\n"
    ].join("");
    const actual = recite(1, 8);
    expect(actual).toEqual(expected);
  });
});
