/*global require, process, console */

(function () {
    "use strict";

    (function (callback) {
        var stdin = process.openStdin(), body = [];

        stdin.on('data', function (chunk) {
            body.push(chunk);
        });

        stdin.on('end', function (chunk) {
            callback(body.join('\n'));
        });

    }(function (body) {

        var fs = require('fs'),
            jslint = require('./jslint.js'),
            ok = jslint.JSLINT(body),
            i,
            error,
            errorType,
            nextError,
            errorCount;

        if (!ok) {
            errorCount = jslint.JSLINT.errors.length;
            for (i = 0; i < errorCount; i += 1) {
                error = jslint.JSLINT.errors[i];
                errorType = "WARNING";
                nextError = i < errorCount ? jslint.JSLINT.errors[i + 1] : null;
                if (error && error.reason && error.reason.match(/^Stopping/) === null) {
                    if (nextError && nextError.reason && nextError.reason.match(/^Stopping/) !== null) {
                        errorType = "ERROR";
                    }
                    console.log([error.line, error.character, errorType, error.reason].join(":"));
                }
            }
        }

    }));

}());
