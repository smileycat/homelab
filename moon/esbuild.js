import { build } from "esbuild";

build({
  entryPoints: ["./src/index.js"],
  bundle: true,
  platform: "node",
  target: ["esnext", "node20"],
  format: "esm",
  outfile: "dist/index.mjs",
  logLevel: "info",
  minify: true,
  banner: {
    js: `const require = (await import('node:module')).createRequire(import.meta.url);
    const __filename = (await import('node:url')).fileURLToPath(import.meta.url);
    const __dirname = (await import('node:path')).dirname(__filename);`,
  },
  // external: []
});
