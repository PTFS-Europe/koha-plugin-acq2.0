const path = require('path');
const { VueLoaderPlugin } = require('vue-loader');
const webpack = require('webpack');


module.exports = {
    entry: './src/main.js',
    output: {
        path: path.resolve(__dirname, './Koha/Plugin/Acquire/dist/'),
        filename: 'acquire.js'
    },
    mode: 'development',
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader'],
            }
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new webpack.DefinePlugin({
            __VUE_OPTIONS_API__: true,
            __VUE_PROD_DEVTOOLS__: false,
        }),
    ],
};