// vue.config.js
module.exports = {
  configureWebpack: (config) => {
    let c = {}
    c.module = {
      rules: [
        { test: /\.ne$/,
          use: [ 'nearley-loader' ],
        },
      ]
    }
    // if (process.env.NODE_ENV === 'production') {
    //   c.module.build = {
    //     assetsPublicPath: '/MathParser'
    //   }
    // }
    return c
  },
  baseUrl: process.env.NODE_ENV === 'production' ? '/MathParser' : undefined
}