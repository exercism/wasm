import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./two-bucket.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

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

const buckets = ['none', 'one', 'two'];

class TwoBucket {
    constructor(bucketOne, bucketTwo, goal, starterBucketet) {
        this.solution = currentInstance.exports.twoBucket(
            bucketOne,
            bucketTwo,
            goal,
            buckets.indexOf(starterBucketet)
        );
        if (this.solution[0] === -1) throw new Error('unsolvable');
    }
    solve() {
        const [moves, goalBucket, otherBucket] = this.solution; 
        return { moves, goalBucket: buckets[goalBucket], otherBucket };
    }
}

describe('TwoBucket', () => {
  describe('Measure using bucket one of size 3 and bucket two of size 5', () => {
    const bucketOne = 3;
    const bucketTwo = 5;
    const goal = 1;

    test('start with bucket one', () => {
      // indicates which bucket to fill first
      const starterBucket = 'one';
      const twoBucket = new TwoBucket(bucketOne, bucketTwo, goal, starterBucket);
      const result = twoBucket.solve();
      // includes the first fill
      expect(result.moves).toEqual(4);
      // which bucket should end up with the desired # of liters
      expect(result.goalBucket).toEqual('one');
      // leftover value in the "other" bucket once the goal has been reached
      expect(result.otherBucket).toEqual(5);
    });

    xtest('start with bucket two', () => {
      const starterBucket = 'two';
      const twoBucket = new TwoBucket(bucketOne, bucketTwo, goal, starterBucket);
      const result = twoBucket.solve();
      expect(result.moves).toEqual(8);
      expect(result.goalBucket).toEqual('two');
      expect(result.otherBucket).toEqual(3);
    });
  });

  describe('Measure using bucket one of size 7 and bucket two of size 11', () => {
    const bucketOne = 7;
    const bucketTwo = 11;
    const goal = 2;

    xtest('start with bucket one', () => {
      const starterBucket = 'one';
      const twoBucket = new TwoBucket(bucketOne, bucketTwo, goal, starterBucket);
      const result = twoBucket.solve();
      expect(result.moves).toEqual(14);
      expect(result.goalBucket).toEqual('one');
      expect(result.otherBucket).toEqual(11);
    });

    xtest('start with bucket two', () => {
      const starterBucket = 'two';
      const twoBucket = new TwoBucket(bucketOne, bucketTwo, goal, starterBucket);
      const result = twoBucket.solve();
      expect(result.moves).toEqual(18);
      expect(result.goalBucket).toEqual('two');
      expect(result.otherBucket).toEqual(7);
    });
  });

  describe('Measure one step using bucket one of size 1 and bucket two of size 3', () => {
    xtest('start with bucket two', () => {
      const twoBucket = new TwoBucket(1, 3, 3, 'two');
      const result = twoBucket.solve();
      expect(result.moves).toEqual(1);
      expect(result.goalBucket).toEqual('two');
      expect(result.otherBucket).toEqual(0);
    });
  });

  describe('Measure using bucket one of size 2 and bucket two of size 3', () => {
    xtest('start with bucket one and end with bucket two', () => {
      const twoBucket = new TwoBucket(2, 3, 3, 'one');
      const result = twoBucket.solve();
      expect(result.moves).toEqual(2);
      expect(result.goalBucket).toEqual('two');
      expect(result.otherBucket).toEqual(2);
    });
  });

  describe('Reachability', () => {
    const bucketOne = 6;
    const bucketTwo = 15;

    xtest('Not possible to reach the goal, start with bucket one', () => {
      expect(() => new TwoBucket(bucketOne, bucketTwo, 5, 'one')).toThrow();
    });

    xtest('Not possible to reach the goal, start with bucket two', () => {
      expect(() => new TwoBucket(bucketOne, bucketTwo, 5, 'two')).toThrow();
    });

    xtest('With the same buckets but a different goal, then it is possible', () => {
      const starterBucket = 'one';
      const goal = 9;
      const twoBucket = new TwoBucket(bucketOne, bucketTwo, goal, starterBucket);
      const result = twoBucket.solve();
      expect(result.moves).toEqual(10);
      expect(result.goalBucket).toEqual('two');
      expect(result.otherBucket).toEqual(0);
    });
  });

  describe('Goal larger than both buckets', () => {
    xtest('Is impossible', () => {
      expect(() => new TwoBucket(5, 7, 8, 'one')).toThrow();
    });
  });
});