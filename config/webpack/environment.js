const { environment } = require('@rails/webpacker')
const { execSync } = require('child_process')

const config = environment.toWebpackConfig()
let gpcGemPath = null

try {
  gpcGemPath = execSync('bundle show govuk_publishing_components')
    .toString()
    .replace(/\n$/, '')
} catch (err) {
  console.error("Expected govuk_publishing_components gem to be installed")
  process.exit()
}

config.resolve.modules.push(`${gpcGemPath}/app/assets/javascripts`)
module.exports = config
