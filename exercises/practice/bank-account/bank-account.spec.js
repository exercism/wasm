import { compileWat, WasmRunner } from "@exercism/wasm-lib";

let wasmModule;
let currentInstance;

beforeAll(async () => {
  try {
    const watPath = new URL("./bank-account.wat", import.meta.url);
    const { buffer } = await compileWat(watPath);
    wasmModule = await WebAssembly.compile(buffer);
  } catch (err) {
    console.log(`Error compiling *.wat: ${err}`);
    process.exit(1);
  }
});

describe("Bank Account", () => {
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

  test("newly opened account has zero balance", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.balance()).toEqual(0);
  });

  xtest("can deposit money", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(100)).toEqual(0);
    expect(account.balance()).toEqual(100);
  });

  xtest("can deposit money sequentially", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(100)).toEqual(0);
    expect(account.deposit(50)).toEqual(0);
    expect(account.balance()).toEqual(150);
  });

  xtest("can withdraw money", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(100)).toEqual(0);
    expect(account.withdraw(50)).toEqual(0);
    expect(account.balance()).toEqual(50);
  });

  xtest("can withdraw money sequentially", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(100)).toEqual(0);
    expect(account.withdraw(20)).toEqual(0);
    expect(account.withdraw(80)).toEqual(0);
    expect(account.balance()).toEqual(0);
  });

  xtest("checking balance of closed account throws error", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.close()).toEqual(0);
    expect(account.balance()).toEqual(-1);
  });

  xtest("deposit into closed account throws error", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.close()).toEqual(0);
    expect(account.deposit(50)).toEqual(-1);
  });

  xtest("withdraw from closed account throws error", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.close()).toEqual(0);
    expect(account.withdraw(50)).toEqual(-1);
  });

  xtest("close already closed account throws error", () => {
    const account = currentInstance.exports;
    expect(account.close()).toEqual(-1);
  });

  xtest("open already opened account throws error", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.open()).toEqual(-1);
  });

  xtest("reopened account does not retain balance", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(50)).toEqual(0);
    expect(account.close()).toEqual(0);
    expect(account.open()).toEqual(0);
    expect(account.balance()).toEqual(0);
  });

  xtest("cannot withdraw more than deposited", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(25)).toEqual(0);
    expect(account.withdraw(50)).toEqual(-2);
  });

  xtest("cannot withdraw negative amount", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(100)).toEqual(0);
    expect(account.withdraw(-50)).toEqual(-2);
  });

  xtest("cannot deposit negative amount", () => {
    const account = currentInstance.exports;
    expect(account.open()).toEqual(0);
    expect(account.deposit(-50)).toEqual(-2);
  });
});
