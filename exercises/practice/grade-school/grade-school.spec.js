import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./grade-school.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function add(name, grade) {
  const inputBufferOffset = 64;
  const inputBufferCapacity = 128;

  const inputLengthEncoded = new TextEncoder().encode(name).length;
  if (inputLengthEncoded > inputBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${inputBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(inputBufferOffset, inputLengthEncoded, name);

  currentInstance.exports.add(
    inputBufferOffset,
    inputLengthEncoded,
    grade
  );
}

function roster() {
  const [outputOffset, outputLength] = currentInstance.exports.roster();

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

function grade(desiredGrade) {
  const [outputOffset, outputLength] = currentInstance.exports.grade(desiredGrade);

  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

describe("Grade School", () => {
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

  test('a new school has an empty roster', () => {
    expect(roster()).toEqual('');
  });

  xtest('adding a student adds them to the roster for the given grade', () => {
    add('Aimee', 2);

    const expectedDb = 'Aimee\n';
    expect(roster()).toEqual(expectedDb);
  });

  xtest('adding more students to the same grade adds them to the roster', () => {
    add('Blair', 2);
    add('James', 2);
    add('Paul', 2);

    const expectedDb = 'Blair\nJames\nPaul\n';
    expect(roster()).toEqual(expectedDb);
  });

  xtest('adding students to different grades adds them to the roster', () => {
    add('Chelsea', 3);
    add('Logan', 7);

    const expectedDb = 'Chelsea\nLogan\n';
    expect(roster()).toEqual(expectedDb);
  });

  xtest('grade returns the students in that grade in alphabetical order', () => {
    add('Franklin', 5);
    add('Bradley', 5);
    add('Jeff', 1);

    const expectedStudents = 'Bradley\nFranklin\n';
    expect(grade(5)).toEqual(expectedStudents);
  });

  xtest('grade returns an empty array if there are no students in that grade', () => {
    expect(grade(1)).toEqual('');
  });

  xtest('the students names in each grade in the roster are sorted', () => {
    add('Jennifer', 4);
    add('Kareem', 6);
    add('Christopher', 4);
    add('Kyle', 3);

    const expectedSortedStudents = 'Kyle\nChristopher\nJennifer\nKareem\n';
    expect(roster()).toEqual(expectedSortedStudents);
  });

  xtest("a student can't be in two different grades", () => {
    add('Aimee', 2);
    add('Aimee', 1);
    expect(grade(2)).toEqual('');
  });
});
