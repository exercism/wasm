import { suite } from "uvu";
import * as assert from "uvu/assert";
import { compileWat, WasmRunner } from "@exercism/wasm-lib";

const test = suite('grade-school');
const xtest = test.skip;
const describe = (_, x) => x();

let wasmModule;
let currentInstance;

test.before(async () => {
  try {
    const watPath = new URL("./grade-school.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

class GradeSchool {
  add(name, grade) {
    const inputBufferOffset = 64;
    const inputBufferCapacity = 128;

    const inputLengthEncoded = new TextEncoder().encode(name).length;
    if (inputLengthEncoded > inputBufferCapacity) {
      throw new Error(
        `String is too large for buffer of size ${inputBufferCapacity} bytes`
      );
    }

    currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, name);

    currentInstance.exports.add(inputBufferOffset, inputLengthEncoded, grade);
  }
  #getOutput(call, ...args) {
    const [outputOffset, outputLength] = currentInstance.exports[call](...args);
    return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
  }
  roster() {
    return this.#getOutput('roster');
  }
  grade(grade) {
    return this.#getOutput('grade', grade);
  }
}

describe('School', () => {
  test.before.each(async () => {
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

  let school;

  test.before.each(() => {
    school = new GradeSchool();
  });

  test('a new school has an empty roster', () => {
    assert.equal(school.roster(), '');
  });

  xtest('adding a student adds them to the roster for the given grade', () => {
    school.add('Aimee', 2);

    const expectedDb = 'Aimee\n';
    assert.equal(school.roster(), expectedDb);
  });

  xtest('adding more students to the same grade adds them to the roster', () => {
    school.add('Blair', 2);
    school.add('James', 2);
    school.add('Paul', 2);

    const expectedDb = 'Blair\nJames\nPaul\n';
    assert.equal(school.roster(), expectedDb);
  });

  xtest('adding students to different grades adds them to the roster', () => {
    school.add('Chelsea', 3);
    school.add('Logan', 7);

    const expectedDb = 'Chelsea\nLogan\n';
    assert.equal(school.roster(), expectedDb);
  });

  xtest('grade returns the students in that grade in alphabetical order', () => {
    school.add('Franklin', 5);
    school.add('Bradley', 5);
    school.add('Jeff', 1);

    const expectedStudents = 'Bradley\nFranklin\n';
    assert.equal(school.grade(5), expectedStudents);
  });

  xtest('grade returns an empty array if there are no students in that grade', () => {
    assert.equal(school.grade(1), '');
  });

  xtest('the students names in each grade in the roster are sorted', () => {
    school.add('Jennifer', 4);
    school.add('Kareem', 6);
    school.add('Christopher', 4);
    school.add('Kyle', 3);

    const expectedSortedStudents = 'Kyle\nChristopher\nJennifer\nKareem\n';
    assert.equal(school.roster(), expectedSortedStudents);
  });

  xtest("a student can't be in two different grades", () => {
    school.add('Aimee', 2);
    school.add('Aimee', 1);
    assert.equal(school.grade(2), '');
  });
});

test.run();

