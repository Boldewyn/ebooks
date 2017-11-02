var webpack = require('webpack');
const env = process.env.NODE_ENV || 'development';
const path = require('path');

const plugins = [];
if (env !== 'development') {
  plugins.push(new webpack.optimize.UglifyJsPlugin({
    compress: { warnings: false, },
    minimize: true,
  }));
}

module.exports = {
  entry: {
    'ebook': './src/js/ebook.js',
    'sw': './src/js/sw.js',
  },
  output: {
    path: path.resolve(__dirname, 'docs/static'),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: ['env']
        },
      },
    ],
  },
  plugins,
  cache: env !== 'development',
  devtool: env === 'development' ? "#inline-source-map" : undefined,
};
