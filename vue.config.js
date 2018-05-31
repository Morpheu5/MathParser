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
    return c
  },
  baseUrl: process.env.NODE_ENV === 'production' ? '/MathParser' : undefined
}