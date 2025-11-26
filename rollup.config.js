import resolve from "@rollup/plugin-node-resolve"

const input = "app/assets/javascripts/shadcn/index.js"

export default [
  // ESM build
  {
    input,
    output: {
      file: "dist/index.esm.js",
      format: "esm",
      sourcemap: true
    },
    external: ["@hotwired/stimulus"],
    plugins: [resolve()]
  },
  // CommonJS build
  {
    input,
    output: {
      file: "dist/index.js",
      format: "cjs",
      sourcemap: true,
      exports: "named"
    },
    external: ["@hotwired/stimulus"],
    plugins: [resolve()]
  }
]
