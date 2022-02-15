import { resolve } from 'path';
import { readFileSync } from 'fs';
const initWabt = require("wabt");

// Reads a *.wat file, parses to a *.wasm binary in-memory, and then compiles to a Wasm module we can instantiate
export async function compileWat (relativePath, options = {}) {
  const wabt = await initWabt();
  const watPath = resolve(__dirname, relativePath);
  return wabt.parseWat(watPath, readFileSync(watPath, "utf8"), options).toBinary({write_debug_names: true});
}
