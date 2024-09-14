import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./atbash-cipher.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function encode(input) {
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
  const [outputOffset, outputLength] = currentInstance.exports.encode(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}


function decode(input) {
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
  const [outputOffset, outputLength] = currentInstance.exports.decode(
    inputBufferOffset,
    inputLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Atbash Cipher", () => {
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

  describe("encode", () => {
    test("encode yes", () => {
      const expected = "bvh";
      const actual = encode("yes");
      expect(actual).toEqual(expected);
    });

    xtest("encode no", () => {
      const expected = "ml";
      const actual = encode("no");
      expect(actual).toEqual(expected);
    });

    xtest("encode OMG", () => {
      const expected = "lnt";
      const actual = encode("OMG");
      expect(actual).toEqual(expected);
    });

    xtest("encode spaces", () => {
      const expected = "lnt";
      const actual = encode("O M G");
      expect(actual).toEqual(expected);
    });

    xtest("encode mindblowingly", () => {
      const expected = "nrmwy oldrm tob";
      const actual = encode("mindblowingly");
      expect(actual).toEqual(expected);
    });

    xtest("encode numbers", () => {
      const expected = "gvhgr mt123 gvhgr mt";
      const actual = encode("Testing,1 2 3, testing.");
      expect(actual).toEqual(expected);
    });

    xtest("encode deep thought", () => {
      const expected = "gifgs rhurx grlm";
      const actual = encode("Truth is fiction.");
      expect(actual).toEqual(expected);
    });

    xtest("encode all the letters", () => {
      const expected = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt";
      const actual = encode("The quick brown fox jumps over the lazy dog.");
      expect(actual).toEqual(expected);
    });
  });

  describe("decode", () => {
    xtest("decode exercism", () => {
      const expected = "exercism";
      const actual = decode("vcvix rhn");
      expect(actual).toEqual(expected);
    });

    xtest("decode a sentence", () => {
      const expected = "anobstacleisoftenasteppingstone";
      const actual = decode("zmlyh gzxov rhlug vmzhg vkkrm thglm v");
      expect(actual).toEqual(expected);
    });

    xtest("decode numbers", () => {
      const expected = "testing123testing";
      const actual = decode("gvhgr mt123 gvhgr mt");
      expect(actual).toEqual(expected);
    });

    xtest("decode all the letters", () => {
      const expected = "thequickbrownfoxjumpsoverthelazydog";
      const actual = decode("gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt");
      expect(actual).toEqual(expected);
    });

    xtest("decode with too many spaces", () => {
      const expected = "exercism";
      const actual = decode("vc vix    r hn");
      expect(actual).toEqual(expected);
    });

    xtest("decode with no spaces", () => {
      const expected = "anobstacleisoftenasteppingstone";
      const actual = decode("zmlyhgzxovrhlugvmzhgvkkrmthglmv");
      expect(actual).toEqual(expected);
    });
  });
});
