import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

function plants(diagram, student) {
  const diagramBufferOffset = 1024;
  const diagramBufferCapacity = 1024;

  const diagramLengthEncoded = new TextEncoder().encode(diagram).length;
  if (diagramLengthEncoded > diagramBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${diagramBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(
    diagramBufferOffset,
    diagramLengthEncoded,
    diagram);

  const studentBufferOffset = 2048;
  const studentBufferCapacity = 1024;

  const studentLengthEncoded = new TextEncoder().encode(student).length;
  if (studentLengthEncoded > studentBufferCapacity) {
    throw new Error(
      `String is too large for buffer of size ${studentBufferCapacity} bytes`
    );
  }

  currentInstance.set_mem_as_utf8(
    studentBufferOffset,
    studentLengthEncoded,
    student
  );

  const [outputOffset, outputLength] = currentInstance.exports.plants(
    diagramBufferOffset,
    diagramLengthEncoded,
    studentBufferOffset,
    studentLengthEncoded
  );

  // Decode JS string from returned offset and length
  return currentInstance.get_mem_as_utf8(outputOffset, outputLength);
}

beforeAll(async () => {
  try {
    const watPath = new URL("./kindergarten-garden.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

describe("Kindergarten Garden", () => {
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

  test("garden with single student", () => {
    const expected = "radishes, clover, grass, grass";
    const actual = plants("RC\nGG", "Alice");
    expect(actual).toEqual(expected);
  });

  xtest("different garden with single student", () => {
    const expected = "violets, clover, radishes, clover";
    const actual = plants("VC\nRC", "Alice");
    expect(actual).toEqual(expected);
  });

  xtest("garden with two students", () => {
    const expected = "clover, grass, radishes, clover";
    const actual = plants("VVCG\nVVRC", "Bob");
    expect(actual).toEqual(expected);
  });

  xtest("second student's garden", () => {
    const expected = "clover, clover, clover, clover";
    const actual = plants("VVCCGG\nVVCCGG", "Bob");
    expect(actual).toEqual(expected);
  });

  xtest("third student's garden", () => {
    const expected = "grass, grass, grass, grass";
    const actual = plants("VVCCGG\nVVCCGG", "Charlie");
    expect(actual).toEqual(expected);
  });

  xtest("for Alice, first student's garden", () => {
    const expected = "violets, radishes, violets, radishes";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Alice");
    expect(actual).toEqual(expected);
  });

  xtest("for Bob, second student's garden", () => {
    const expected = "clover, grass, clover, clover";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Bob");
    expect(actual).toEqual(expected);
  });

  xtest("for Charlie", () => {
    const expected = "violets, violets, clover, grass";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Charlie");
    expect(actual).toEqual(expected);
  });

  xtest("for David", () => {
    const expected = "radishes, violets, clover, radishes";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "David");
    expect(actual).toEqual(expected);
  });

  xtest("for Eve", () => {
    const expected = "clover, grass, radishes, grass";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Eve");
    expect(actual).toEqual(expected);
  });

  xtest("for Fred", () => {
    const expected = "grass, clover, violets, clover";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Fred");
    expect(actual).toEqual(expected);
  });

  xtest("for Ginny", () => {
    const expected = "clover, grass, grass, clover";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Ginny");
    expect(actual).toEqual(expected);
  });

  xtest("for Harriet", () => {
    const expected = "violets, radishes, radishes, violets";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Harriet");
    expect(actual).toEqual(expected);
  });

  xtest("for Ileana", () => {
    const expected = "grass, clover, violets, clover";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Ileana");
    expect(actual).toEqual(expected);
  });

  xtest("for Joseph", () => {
    const expected = "violets, clover, violets, grass";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Joseph");
    expect(actual).toEqual(expected);
  });

  xtest("for Kincaid, second to last student's garden", () => {
    const expected = "grass, clover, clover, grass";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Kincaid");
    expect(actual).toEqual(expected);
  });

  xtest("for Larry, last student's garden", () => {
    const expected = "grass, violets, clover, violets";
    const actual = plants("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV", "Larry");
    expect(actual).toEqual(expected);
  });
});
