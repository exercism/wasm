import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function isIsogram(input = "") {
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
  return currentInstance.exports.isIsogram(
    inputBufferOffset,
    inputLengthEncoded
  );
}

beforeAll(async () => {
  try {
    const watPath = new URL("./isogram.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("Isogram()", () => {
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

  test("empty_string", () => {
    expect(isIsogram("")).toBe(1);
  });

  xtest("isogram_with_only_lower_case_characters", () => {
    expect(isIsogram("isogram")).toBe(1);
  });

  xtest("word_with_one_duplicated_character", () => {
    expect(isIsogram("eleven")).toBe(0);
  });

  xtest("word_with_one_duplicated_character_from_the_end_of_the_alphabet", () => {
    expect(isIsogram("zzyzx")).toBe(0);
  });

  xtest("longest_reported_english_isogram", () => {
    expect(isIsogram("subdermatoglyphic")).toBe(1);
  });

  xtest("word_with_duplicated_character_in_mixed_case", () => {
    expect(isIsogram("Alphabet")).toBe(0);
  });

  xtest("word_with_duplicated_character_in_mixed_case_lowercase_first", () => {
    expect(isIsogram("alphAbet")).toBe(0);
  });

  xtest("hypothetical_isogrammic_word_with_hyphen", () => {
    expect(isIsogram("thumbscrew-japingly")).toBe(1);
  });

  xtest("hypothetical_word_with_duplicated_character_following_hyphen", () => {
    expect(isIsogram("thumbscrew-jappingly")).toBe(0);
  });

  xtest("isogram_with_duplicated_hyphen", () => {
    expect(isIsogram("six-year-old")).toBe(1);
  });

  xtest("made_up_name_that_is_an_isogram", () => {
    expect(isIsogram("Emily Jung Schwartzkopf")).toBe(1);
  });

  xtest("duplicated_character_in_the_middle", () => {
    expect(isIsogram("accentor")).toBe(0);
  });

  xtest("same_first_and_last_characters", () => {
    expect(isIsogram("angola")).toBe(0);
  });

  xtest("word_with_duplicated_character_and_with_two_hyphens", () => {
    expect(isIsogram("up-to-date")).toBe(0);
  });
});
