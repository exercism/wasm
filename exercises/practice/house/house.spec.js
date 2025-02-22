import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./house.wat", import.meta.url);
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

describe("House", () => {
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

  test("verse one - the house that jack built", () => {
    const expected =
      "This is the house that Jack built.";
    const actual = recite(1, 1);
    expect(actual).toEqual(expected);
  });

  xtest("verse two - the malt that lay", () => {
    const expected =
      "This is the malt that lay in the house that Jack built.";
    const actual = recite(2, 2);
    expect(actual).toEqual(expected);
  });

  xtest("verse three - the rat that ate", () => {
    const expected =
      "This is the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(3, 3);
    expect(actual).toEqual(expected);
  });

  xtest("verse four - the cat that killed", () => {
    const expected =
      "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(4, 4);
    expect(actual).toEqual(expected);
  });

  xtest("verse five - the dog that worried", () => {
    const expected =
      "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(5, 5);
    expect(actual).toEqual(expected);
  });

  xtest("verse six - the cow with the crumpled horn", () => {
    const expected =
      "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(6, 6);
    expect(actual).toEqual(expected);
  });

  xtest("verse seven - the maiden all forlorn", () => {
    const expected =
      "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(7, 7);
    expect(actual).toEqual(expected);
  });

  xtest("verse eight - the man all tattered and torn", () => {
    const expected =
      "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(8, 8);
    expect(actual).toEqual(expected);
  });

  xtest("verse nine - the priest all shaven and shorn", () => {
    const expected =
      "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(9, 9);
    expect(actual).toEqual(expected);
  });

  xtest("verse 10 - the rooster that crowed in the morn", () => {
    const expected =
      "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(10, 10);
    expect(actual).toEqual(expected);
  });

  xtest("verse 11 - the farmer sowing his corn", () => {
    const expected =
      "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(11, 11);
    expect(actual).toEqual(expected);
  });

  xtest("verse 12 - the horse and the hound and the horn", () => {
    const expected =
      "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.";
    const actual = recite(12, 12);
    expect(actual).toEqual(expected);
  });

  xtest("multiple verses", () => {
    const expected = [
      "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."
    ].join("\n");
    const actual = recite(4, 8);
    expect(actual).toEqual(expected);
  });

  xtest("full rhyme", () => {
    const expected = [
      "This is the house that Jack built.",
      "This is the malt that lay in the house that Jack built.",
      "This is the rat that ate the malt that lay in the house that Jack built.",
      "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.",
      "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."
    ].join("\n");
    const actual = recite(1, 12);
    expect(actual).toEqual(expected);
  });
});
