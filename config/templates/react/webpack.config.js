var path = require('path');
var MiniCssExtractPlugin = require('mini-css-extract-plugin')
var HtmlWebpackPlugin = require('html-webpack-plugin')
var CleanWebpackPlugin = require('clean-webpack-plugin')

module.exports = {
    entry: ['@babel/polyfill', '<ENTRY POINT>'],
    output: {
        path: path.resolve(__dirname, '<BUILD DIR>'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader'
                }
            },
            {
                test: /\.(sa|sc|c)ss$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    'postcss-loader',
                    'sass-loader',
                ],
            },
            {
                test: /\.(png|jpg)/,
                use: {
                    loader: 'url-loader'
                }
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: path.resolve(__dirname, '<HTML TEMPLATE LOCATION>'),
            title: "Coffer: Budget Application"
        }),
        new CleanWebpackPlugin(),
        new MiniCssExtractPlugin({
            filename: 'main.css'
        })
    ]
};
