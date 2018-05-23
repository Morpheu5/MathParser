// vue.config.js
module.exports = {
    configureWebpack: {
      module: {
        rules: [
          {
            test: /\.ne$/,
            use: [
              'nearley-loader',
            ],
          },
        ]
      }
    }
  }