import resolve from "@rollup/plugin-node-resolve"

const builds = [
  {
    input: ".tsbuild/index.js",
    esm: "dist/index.esm.js",
    cjs: "dist/index.js"
  },
  {
    input: ".tsbuild/controllers/index.js",
    esm: "dist/controllers/index.esm.js",
    cjs: "dist/controllers/index.js"
  }
]

export default builds.flatMap((build) => [
  {
    input: build.input,
    output: {
      file: build.esm,
      format: "esm",
      sourcemap: true
    },
    external: ["@hotwired/stimulus"],
    plugins: [resolve()]
  },
  {
    input: build.input,
    output: {
      file: build.cjs,
      format: "cjs",
      sourcemap: true,
      exports: "named"
    },
    external: ["@hotwired/stimulus"],
    plugins: [resolve()]
  }
])
