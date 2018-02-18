let fs = require("fs");
let process = require("process");
let path = require("path");
let webidl = require("./webidl-parser");

const args = process.argv.slice(2);
const fileArgs = args.filter(arg => !arg.startsWith("-"));
const optionArgs = args.filter(arg => arg.startsWith("-"));

let debug = false;
optionArgs.forEach(option => {
    if (option === "-debug" || option === "--debug") {
        debug = true;
        console.log("Debugging mode");
    }
    else {
        throw new Error("Unknown option " + option);
    }
});

fileArgs.forEach(parseFileOrDirectory);

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
}

function parseFile(file) {
    const fileContents = fs.readFileSync(file, { encoding: "utf8" });
    try {
        const parsed = webidl.parse(fileContents);
        parsed.forEach(entry => {
            if (debug) {
                console.log(entry);
                if (entry.members) {
                    entry.members.forEach(member => {
                        console.log(member);
                    });
                }
            }
            else {
                if (entry.kind === "interface") {
                    (entry.members || []).forEach(member => {
                        console.log(entry.name + "." + member.name);
                    });
                }
            }
        });
    }
    catch (error) {
        console.log("Error parsing " + file + " (" + error.location.start.line + ":" + error.location.start.column + " - " + error.location.end.line + ":" + error.location.end.column + "): " + error.message);
        console.log();
        if (error.location.start.line === error.location.end.line) {
            console.log(fileContents.split("\n")[error.location.start.line - 1]);
            let space = "";
            for (let idx = 0; idx < error.location.start.column - 1; ++idx) {
                space += " ";
            }
            for (let idx = 0; idx < error.location.end.column - error.location.start.column; ++idx) {
                space += "^";
            }
            console.log(space);
        }
        else {
            const lines = fileContents.split("\n");
            for (let line = error.location.start.line; line <= error.location.end.line; ++line) {
                console.log(lines[line - 1]);
            }
        }
    }
}
