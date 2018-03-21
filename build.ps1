pegjs webidl-parser.pegjs;
$webidlPaths = (gci webidl -dir).FullName;
node parse-webidl-files.js $webidlPaths | Out-File -Encoding utf8 -filePath .\api-list.json
$template = (gc injectscript.template.js);
$insertIdx = $template.IndexOf("%APILIST%");
$template[0..($insertIdx - 1)] | Out-File -Encoding utf8 -FilePath .\src\injectscript.js
gc api-list.json | Out-File -Encoding utf8 -Append -FilePath .\src\injectscript.js
$template[($insertIdx + 1)..($template.length - 1)] | Out-File -Encoding utf8 -Append -FilePath .\src\injectscript.js