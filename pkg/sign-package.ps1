$password = Read-Host pvkPassword
signtool sign /fd SHA256 /a /f mykey.pfx /p $password (dir -r -fi *appx).fullname
