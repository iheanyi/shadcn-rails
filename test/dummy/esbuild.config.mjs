import * as esbuild from 'esbuild'
import { resolve, dirname } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

// Path to the gem's JS directory (relative to test/dummy)
const gemJsPath = resolve(__dirname, '../../app/assets/javascripts/shadcn')

const ctx = await esbuild.context({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  loader: { '.js': 'jsx' },
  alias: {
    'shadcn-rails-stimulus': resolve(__dirname, '../../app/assets/javascripts/shadcn/index.js')
  },
  logLevel: 'info',
})

// Watch for changes in both the app and the gem's JS directory
console.log(`[esbuild] Watching for changes in:`)
console.log(`  - app/javascript`)
console.log(`  - ${gemJsPath}`)

await ctx.watch()

// Keep the process running
process.stdin.resume()
