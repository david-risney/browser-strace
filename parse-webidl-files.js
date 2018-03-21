(() => {
    let fs = require("fs");
    let process = require("process");
    let path = require("path");
    let webidl = require("./webidl-parser");

    const args = process.argv.slice(2);
    const fileArgs = args.filter(arg => !arg.startsWith("-"));
    const optionArgs = args.filter(arg => arg.startsWith("-"));

    let debug = false;
    let onlyErrors = false;

    let nameToEntry = {};
    let includes = [];

    optionArgs.forEach(option => {
        if (option === "-debug" || option === "--debug") {
            debug = true;
            console.log("Debugging mode");
        }
        else if (option === "-onlyErrors" || option === "--onlyErrors") {
            onlyErrors = true;
            console.log("Showing only errors");
        }
        else {
            throw new Error("Unknown option " + option);
        }
    });

    if (!onlyErrors && !debug) {
        console.log('[');
    }
    fileArgs.forEach(parseFileOrDirectory);
    if (!onlyErrors && !debug) {
        console.log('];');
    }

    function parseFileOrDirectory(fileOrDirectory) {
        const stats = fs.statSync(fileOrDirectory);
        if (stats.isDirectory()) {
            parseDirectory(fileOrDirectory);
        }
        else if (stats.isFile()) {
            parseFile(fileOrDirectory);
        }
        else {
            throw new Error("Not a valid path: " + fileOrDirectory);
        }
    }

    function parseDirectory(directory) {
        const files = fs.readdirSync(directory);
        files.map((file) => path.join(directory, file)).forEach(parseFile);

        includes.forEach(include => {
            const base = nameToEntry[include.base];
            const derived = nameToEntry[include.derived];
            (base.members || []).forEach(member => {
                console.log('    "' + derived.name + "." + member.name + '",',);
            });
        });
    }

    function parseFile(file) {
        const fileContents = fs.readFileSync(file, { encoding: "utf8" });
        try {
            const parsed = webidl.parse(fileContents);
            parsed.forEach(entry => {
                nameToEntry[entry.name] = entry;
            });

            parsed.forEach(entry => {
                if (!onlyErrors) {
                    if (debug) {
                        console.log(entry);
                        if (entry.members) {
                            entry.members.forEach(member => {
                                console.log(member);
                            });
                        }
                    }
                    else {
                        if (entry.kind === "interface" && !entry.mixin) {
                            (entry.members || []).forEach(member => {
                                console.log('    "' + entry.name + "." + member.name + '",',);
                            });
                        }
                        else if (entry.kind === "includes") {
                            includes.push(entry);
                        }
                    }
                }
            });
        }
        catch (error) {
            if (error.location) {
                console.error("Error parsing " + file + " (" + error.location.start.line + ":" + error.location.start.column + " - " + error.location.end.line + ":" + error.location.end.column + "): " + error.message);
                console.error();
                if (error.location.start.line === error.location.end.line) {
                    console.error(fileContents.split("\n")[error.location.start.line - 1]);
                    let space = "";
                    for (let idx = 0; idx < error.location.start.column - 1; ++idx) {
                        space += " ";
                    }
                    for (let idx = 0; idx < error.location.end.column - error.location.start.column; ++idx) {
                        space += "^";
                    }
                    console.error(space);
                }
                else {
                    const lines = fileContents.split("\n");
                    for (let line = error.location.start.line; line <= error.location.end.line; ++line) {
                        console.error(lines[line - 1]);
                    }
                }
            }
            else {
                console.error("Error parsing file " + file + ": " + error);
                console.error(error);
            }
        }
    }
})();