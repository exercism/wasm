import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./bob.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function response(input) {
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
  const [outputOffset, outputLength] = currentInstance.exports.response(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Bob", () => {
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

  test("stating something", () => {
    const expected = "Whatever.";
    const actual = response("Tom-ay-to, tom-aaaah-to.");
    expect(actual).toEqual(expected);
  });

  xtest("shouting", () => {
    const expected = "Whoa, chill out!";
    const actual = response("WATCH OUT!");
    expect(actual).toEqual(expected);
  });

  xtest("shouting gibberish", () => {
    const expected = "Whoa, chill out!";
    const actual = response("FCECDFCAAB");
    expect(actual).toEqual(expected);
  });

  xtest("asking a question", () => {
    const expected = "Sure.";
    const actual = response("Does this cryogenic chamber make me look fat?");
    expect(actual).toEqual(expected);
  });

  xtest("asking a numeric question", () => {
    const expected = "Sure.";
    const actual = response("You are, what, like 15?");
    expect(actual).toEqual(expected);
  });

  xtest("asking gibberish", () => {
    const expected = "Sure.";
    const actual = response("fffbbcbeab?");
    expect(actual).toEqual(expected);
  });

  xtest("talking forcefully", () => {
    const expected = "Whatever.";
    const actual = response("Hi there!");
    expect(actual).toEqual(expected);
  });

  xtest("using acronyms in regular speech", () => {
    const expected = "Whatever.";
    const actual = response("It's OK if you don't want to go work for NASA.");
    expect(actual).toEqual(expected);
  });

  xtest("forceful question", () => {
    const expected = "Calm down, I know what I'm doing!";
    const actual = response("WHAT'S GOING ON?");
    expect(actual).toEqual(expected);
  });

  xtest("shouting numbers", () => {
    const expected = "Whoa, chill out!";
    const actual = response("1, 2, 3 GO!");
    expect(actual).toEqual(expected);
  });

  xtest("no letters", () => {
    const expected = "Whatever.";
    const actual = response("1, 2, 3");
    expect(actual).toEqual(expected);
  });

  xtest("question with no letters", () => {
    const expected = "Sure.";
    const actual = response("4?");
    expect(actual).toEqual(expected);
  });

  xtest("shouting with special characters", () => {
    const expected = "Whoa, chill out!";
    const actual = response("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!");
    expect(actual).toEqual(expected);
  });

  xtest("shouting with no exclamation mark", () => {
    const expected = "Whoa, chill out!";
    const actual = response("I HATE THE DENTIST");
    expect(actual).toEqual(expected);
  });

  xtest("statement containing question mark", () => {
    const expected = "Whatever.";
    const actual = response("Ending with ? means a question.");
    expect(actual).toEqual(expected);
  });

  xtest("non-letters with question", () => {
    const expected = "Sure.";
    const actual = response(":) ?");
    expect(actual).toEqual(expected);
  });

  xtest("prattling on", () => {
    const expected = "Sure.";
    const actual = response("Wait! Hang on. Are you going to be OK?");
    expect(actual).toEqual(expected);
  });

  xtest("silence", () => {
    const expected = "Fine. Be that way!";
    const actual = response("");
    expect(actual).toEqual(expected);
  });

  xtest("prolonged silence", () => {
    const expected = "Fine. Be that way!";
    const actual = response("          ");
    expect(actual).toEqual(expected);
  });

  xtest("alternate silence", () => {
    const expected = "Fine. Be that way!";
    const actual = response("\t\t\t\t\t\t\t\t\t\t");
    expect(actual).toEqual(expected);
  });

  xtest("starting with whitespace", () => {
    const expected = "Whatever.";
    const actual = response("         hmmmmmmm...");
    expect(actual).toEqual(expected);
  });

  xtest("ending with whitespace", () => {
    const expected = "Sure.";
    const actual = response("Okay if like my  spacebar  quite a bit?   ");
    expect(actual).toEqual(expected);
  });

  xtest("other whitespace", () => {
    const expected = "Fine. Be that way!";
    const actual = response("\n\r \t");
    expect(actual).toEqual(expected);
  });

  xtest("non-question ending with whitespace", () => {
    const expected = "Whatever.";
    const actual = response("This is a statement ending with whitespace      ");
    expect(actual).toEqual(expected);
  });

  xtest("multiple line question", () => {
    const expected = "Sure.";
    const actual = response("\nDoes this cryogenic chamber make\n me look fat?");
    expect(actual).toEqual(expected);
  });
});
