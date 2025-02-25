import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./high-scores.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

const inputBufferOffset = 64;
const inputBufferCapacity = 128;
const u32Size = 4;

export class HighScores {
  #scores;
  #encodedLength;
  constructor(scores = []) {
    this.#scores = currentInstance.get_mem_as_u32(inputBufferOffset, inputBufferCapacity);
    this.#scores.set(scores);
    this.#encodedLength = scores.length * u32Size;
  }
  get scores() {
    return [...this.#scores].filter(Boolean);
  }
  get latest() {
    return currentInstance.exports.latest(inputBufferOffset, this.#encodedLength);
  }
  get personalBest() {
    return currentInstance.exports.personalBest(inputBufferOffset, this.#encodedLength);
  }
  get personalTopThree() {
    return currentInstance.exports.personalTopThree(inputBufferOffset, this.#encodedLength).filter(Boolean);
  }
}

describe('High Scores Test Suite', () => {
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
  test('List of scores', () => {
    const input = [30, 50, 20, 70];
    expect(new HighScores(input).scores).toEqual([30, 50, 20, 70]);
  });

  xtest('Latest score', () => {
    const input = [100, 0, 90, 30];
    expect(new HighScores(input).latest).toEqual(30);
  });

  xtest('Personal best', () => {
    const input = [40, 100, 70];
    expect(new HighScores(input).personalBest).toEqual(100);
  });

  describe('Top 3 scores', () => {
    xtest('Personal top three from a list of scores', () => {
      const input = [10, 30, 90, 30, 100, 20, 10, 0, 30, 40, 40, 70, 70];
      expect(new HighScores(input).personalTopThree).toEqual([100, 90, 70]);
    });

    xtest('Personal top highest to lowest', () => {
      const input = [20, 10, 30];
      expect(new HighScores(input).personalTopThree).toEqual([30, 20, 10]);
    });

    xtest('Personal top when there is a tie', () => {
      const input = [40, 20, 40, 30];
      expect(new HighScores(input).personalTopThree).toEqual([40, 40, 30]);
    });

    xtest('Personal top when there are less than 3', () => {
      const input = [30, 70];
      expect(new HighScores(input).personalTopThree).toEqual([70, 30]);
    });

    xtest('Personal top when there is only one', () => {
      const input = [40];
      expect(new HighScores(input).personalTopThree).toEqual([40]);
    });
  });
});