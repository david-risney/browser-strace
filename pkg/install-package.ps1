Get-AppxPackage *BrowserStrace* | Remove-AppxPackage
Add-AppxPackage (dir -r -fi *.appx).fullname
