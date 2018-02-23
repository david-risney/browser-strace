pegjs webidl-parser.pegjs;
$webidlPaths = (gci webidl -dir).FullName;
node parse-webidl-files.js $webidlPaths | Out-File -Encoding utf8 -filePath .\api-list.json