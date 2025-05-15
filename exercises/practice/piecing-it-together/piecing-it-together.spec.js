import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./piecing-it-together.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

export const jigsawData = (data) => {
  const [
    pieces,
    border,
    inside,
    rows,
    columns,
    aspectRatio,
    formatId
  ] = currentInstance.exports.jigsawData(
    data.pieces || 0,
    data.border || 0,
    data.inside || 0,
    data.rows || 0,
    data.columns || 0,
    data.aspectRatio || 0,
    currentInstance.exports[data.format] || 0,
  );

  if (pieces === +currentInstance.exports.INSUFFICIENT)
    throw new Error('Insufficient data');
  if (pieces === +currentInstance.exports.CONTRADICTORY)
    throw new Error('Contradictory data');

  return {
    pieces,
    border,
    inside,
    rows,
    columns,
    aspectRatio,
    format: [null, 'landscape', 'square', 'portrait'][formatId]
  };
}

describe("Piecing it together", () => {
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

	test("1000 pieces puzzle with 1.6 aspect ratio", () => {
		const expected = {
			pieces: 1000,
			border: 126,
			inside: 874,
			rows: 25,
			columns: 40,
			aspectRatio: 1.6,
			format: "landscape",
		};
		const actual = jigsawData({
			pieces: 1000,
			aspectRatio: 1.6,
		});
		expect(actual).toEqual(expected);
	});

	xtest("square puzzle with 32 rows", () => {
		const expected = {
			pieces: 1024,
			border: 124,
			inside: 900,
			rows: 32,
			columns: 32,
			aspectRatio: 1.0,
			format: "square",
		};
		const actual = jigsawData({
			rows: 32,
			format: "square",
		});
		expect(actual).toEqual(expected);
	});

	xtest("400 pieces square puzzle with only inside pieces and aspect ratio", () => {
		const expected = {
			pieces: 400,
			border: 76,
			inside: 324,
			rows: 20,
			columns: 20,
			aspectRatio: 1.0,
			format: "square",
		};
		const actual = jigsawData({
			inside: 324,
			aspectRatio: 1.0,
		});
		expect(actual).toEqual(expected);
	});

	xtest("1500 pieces landscape puzzle with 30 rows and 1.6 aspect ratio", () => {
		const expected = {
			pieces: 1500,
			border: 156,
			inside: 1344,
			rows: 30,
			columns: 50,
			aspectRatio: 1.6666666666666667,
			format: "landscape",
		};
		const actual = jigsawData({
			rows: 30,
			aspectRatio: 1.6666666666666667,
		});
		expect(actual).toEqual(expected);
	});

	xtest("300 pieces portrait puzzle with 70 border pieces", () => {
		const expected = {
			pieces: 300,
			border: 70,
			inside: 230,
			rows: 25,
			columns: 12,
			aspectRatio: 0.48,
			format: "portrait",
		};
		const actual = jigsawData({
			pieces: 300,
			border: 70,
			format: "portrait",
		});
		expect(actual).toEqual(expected);
	});

	xtest("puzzle with insufficient data", () => {
		expect(() =>
			jigsawData({
				pieces: 1500,
				format: "landscape",
			}),
		).toThrow("Insufficient data");
	});

	xtest("puzzle with contradictory data", () => {
		expect(() =>
			jigsawData({
				rows: 100,
				columns: 1000,
				format: "square",
			}),
		).toThrow("Contradictory data");
	});
});
