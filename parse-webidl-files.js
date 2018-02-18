let fs = require("fs");
let process = require("process");
let path = require("path");
let webidl = require("./webidl-parser");

process.argv.slice(2).forEach(parseFileOrDirectory);
console.log("-- completed --");

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
    console.log("-- starting " + file + " --");
    const fileContents = fs.readFileSync(file, { encoding: "utf8" });
    console.log(fileContents);
    try {
        const parsed = webidl.parse(fileContents);
        console.log(parsed + " " + (!!parsed));
        console.log(JSON.stringify(parsed));
    }
    catch (error) {
        console.log("Error parsing: " + error + " " + error.message + " " + JSON.stringify(error));
    }
}
