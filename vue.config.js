// vue.config.js

const path = require("path")

module.exports = {
  configureWebpack: (config) => {
    let c = {}
    c.module = {
      rules: [
        { test: /\.ne$/,
          use: [ 'nearley-es6-loader' ],
        },
      ]
    }
    c.resolveLoader = {
      modules: ['node_modules', path.resolve(__dirname, 'src/loaders')]
    }
    c.devtool = 'eval-source-map'
    return c
  }
}