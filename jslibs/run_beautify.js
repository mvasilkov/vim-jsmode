/*global require, process, console */

(function () {
    "use strict";

    var fs = require('fs'),
        beatify = require('./beautify.js'),
        args = process.argv.slice(2),
        fname = args[0],
        source = fs.readFileSync(fname, "utf8");

    console.log(beatify.js_beautify(source, {
        jslint_happy: true
    }));

}());
