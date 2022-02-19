import { compileWat, WasmRunner } from "wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./triangle.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
    process.exit(1);
  }
});

describe("Triangle", () => {
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

  describe("equilateral triangle", () => {
    test("all sides are equal", () => {
      expect(currentInstance.exports.isEquilateral(2, 2, 2)).toBe(1);
    });

    xtest("any side is unequal", () => {
      expect(currentInstance.exports.isEquilateral(2, 3, 2)).toBe(0);
    });

    xtest("no sides are equal", () => {
      expect(currentInstance.exports.isEquilateral(5, 4, 6)).toBe(0);
    });

    xtest("all zero sides is not a triangle", () => {
      expect(currentInstance.exports.isEquilateral(0, 0, 0)).toBe(0);
    });

    xtest("sides may be floats", () => {
      expect(currentInstance.exports.isEquilateral(0.5, 0.5, 0.5)).toBe(1);
    });
  });

  describe("isosceles triangle", () => {
    xtest("last two sides are equal", () => {
      expect(currentInstance.exports.isIsosceles(3, 4, 4)).toBe(1);
    });

    xtest("first two sides are equal", () => {
      expect(currentInstance.exports.isIsosceles(4, 4, 3)).toBe(1);
    });

    xtest("first and last sides are equal", () => {
      expect(currentInstance.exports.isIsosceles(4, 3, 4)).toBe(1);
    });

    xtest("equilateral triangles are also isosceles", () => {
      expect(currentInstance.exports.isIsosceles(4, 4, 4)).toBe(1);
    });

    xtest("no sides are equal", () => {
      expect(currentInstance.exports.isIsosceles(2, 3, 4)).toBe(0);
    });

    xtest("first triangle inequality violation", () => {
      expect(currentInstance.exports.isIsosceles(1, 1, 3)).toBe(0);
    });

    xtest("second triangle inequality violation", () => {
      expect(currentInstance.exports.isIsosceles(1, 3, 1)).toBe(0);
    });

    xtest("third triangle inequality violation", () => {
      expect(currentInstance.exports.isIsosceles(3, 1, 1)).toBe(0);
    });

    xtest("sides may be floats", () => {
      expect(currentInstance.exports.isIsosceles(0.5, 0.4, 0.5)).toBe(1);
    });
  });

  describe("scalene triangle", () => {
    xtest("no sides are equal", () => {
      expect(currentInstance.exports.isScalene(5, 4, 6)).toBe(1);
    });

    xtest("all sides are equal", () => {
      expect(currentInstance.exports.isScalene(4, 4, 4)).toBe(0);
    });

    xtest("two sides are equal", () => {
      expect(currentInstance.exports.isScalene(4, 4, 3)).toBe(0);
    });

    xtest("may not violate triangle inequality", () => {
      expect(currentInstance.exports.isScalene(7, 3, 2)).toBe(0);
    });

    xtest("sides may be floats", () => {
      expect(currentInstance.exports.isScalene(0.5, 0.4, 0.6)).toBe(1);
    });
  });
});
