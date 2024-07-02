import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./knapsack.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: \n${err}`);
    process.exit(1);
  }
});

function findMaximumValue(items, capacity) {
  let data = currentInstance.get_mem_as_i32(0, items.length * 2);
  for (let i in items) {
    const index = i * 2;
    data[index] = items[i]["weight"];
    data[index + 1] = items[i]["value"];
  }
  return currentInstance.exports.maximumValue(items.length, capacity);
}

describe("knapsack", () => {
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

  test("no items", () => {
    expect(findMaximumValue([], 100)).toEqual(0);
  });

  xtest("one item, too heavy", () => {
    const items = [{ "weight": 100, "value": 1 }];
    expect(findMaximumValue(items, 10)).toEqual(0);
  });

  xtest("five items (cannot be greedy by weight)", () => {
    const items = [
      { "weight": 2, "value": 5 },
      { "weight": 2, "value": 5 },
      { "weight": 2, "value": 5 },
      { "weight": 2, "value": 5 },
      { "weight": 10, "value": 21 }
    ];
    expect(findMaximumValue(items, 10)).toEqual(21);
  });

  xtest("five items (cannot be greedy by value)", () => {
    const items = [
      { "weight": 2, "value": 20 },
      { "weight": 2, "value": 20 },
      { "weight": 2, "value": 20 },
      { "weight": 2, "value": 20 },
      { "weight": 10, "value": 50 }
    ];
    expect(findMaximumValue(items, 10)).toEqual(80);
  });

  xtest("example knapsack", () => {
    const items = [
      { "weight": 5, "value": 10 },
      { "weight": 4, "value": 40 },
      { "weight": 6, "value": 30 },
      { "weight": 4, "value": 50 }
    ];
    expect(findMaximumValue(items, 10)).toEqual(90);
  });

  xtest("8 items", () => {
    const items = [
      { "weight": 25, "value": 350 },
      { "weight": 35, "value": 400 },
      { "weight": 45, "value": 450 },
      { "weight": 5, "value": 20 },
      { "weight": 25, "value": 70 },
      { "weight": 3, "value": 8 },
      { "weight": 2, "value": 5 },
      { "weight": 2, "value": 5 }
    ];
    expect(findMaximumValue(items, 104)).toEqual(900);
  });

  xtest("15 items", () => {
    const items = [
      { "weight": 70, "value": 135 },
      { "weight": 73, "value": 139 },
      { "weight": 77, "value": 149 },
      { "weight": 80, "value": 150 },
      { "weight": 82, "value": 156 },
      { "weight": 87, "value": 163 },
      { "weight": 90, "value": 173 },
      { "weight": 94, "value": 184 },
      { "weight": 98, "value": 192 },
      { "weight": 106, "value": 201 },
      { "weight": 110, "value": 210 },
      { "weight": 113, "value": 214 },
      { "weight": 115, "value": 221 },
      { "weight": 118, "value": 229 },
      { "weight": 120, "value": 240 }
    ];
    expect(findMaximumValue(items, 750)).toEqual(1458);
  });
});
