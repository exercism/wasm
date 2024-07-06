import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./micro-blog.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function truncate(input) {
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
  const [outputOffset, outputLength] = currentInstance.exports.truncate(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Truncate", () => {
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

  test("English language short", () => {
    const expected = "Hi";
    const actual = truncate("Hi");
    expect(actual).toEqual(expected);
  });

  xtest("English language long", () => {
    const expected = "Hello";
    const actual = truncate("Hello there");
    expect(actual).toEqual(expected);
  });

  xtest("German language short (broth)", () => {
    const expected = "brühe";
    const actual = truncate("brühe");
    expect(actual).toEqual(expected);
  });

  xtest("German language long (bear carpet → beards)", () => {
    const expected = "Bärte";
    const actual = truncate("Bärteppich");
    expect(actual).toEqual(expected);
  });

  xtest("Bulgarian language short (good)", () => {
    const expected = "Добър";
    const actual = truncate("Добър");
    expect(actual).toEqual(expected);
  });

  xtest("Greek language short (health)", () => {
    const expected = "υγειά";
    const actual = truncate("υγειά");
    expect(actual).toEqual(expected);
  });

  xtest("Maths short", () => {
    const expected = "a=πr²";
    const actual = truncate("a=πr²");
    expect(actual).toEqual(expected);
  });

  xtest("Maths long", () => {
    const expected = "∅⊊ℕ⊊ℤ";
    const actual = truncate("∅⊊ℕ⊊ℤ⊊ℚ⊊ℝ⊊ℂ");
    expect(actual).toEqual(expected);
  });

  xtest("English and emoji short", () => {
    const expected = "Fly 🛫";
    const actual = truncate("Fly 🛫");
    expect(actual).toEqual(expected);
  });

  xtest("Emoji short", () => {
    const expected = "💇";
    const actual = truncate("💇");
    expect(actual).toEqual(expected);
  });

  xtest("Emoji long", () => {
    const expected = "❄🌡🤧🤒🏥";
    const actual = truncate("❄🌡🤧🤒🏥🕰😀");
    expect(actual).toEqual(expected);
  });

  xtest("Royal Flush?", () => {
    const expected = "🃎🂸🃅🃋🃍";
    const actual = truncate("🃎🂸🃅🃋🃍🃁🃊");
    expect(actual).toEqual(expected);
  });
});
