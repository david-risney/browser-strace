# makecert /n "CN=6A6BD061-7104-4902-A375-9DE2439CC857" /r /h 0 /eku "1.3.6.1.5.5.7.3.3,1.3.6.1.4.1.311.10.3.13"  /sv mykey.pvk mykey.cer
if (!(test-path MyKey.pfx)) {
    [void](New-SelfSignedCertificate -Type Custom -Subject "CN=6A6BD061-7104-4902-A375-9DE2439CC857" -KeyUsage DigitalSignature -FriendlyName "BrowserStraceCert" -CertStoreLocation "Cert:\LocalMachine\My")
    pushd
    Set-Location Cert:\LocalMachine\My
    $thumbprint = (gci | where FriendlyName -eq "BrowserStraceCert").Thumbprint
    popd
    
    # $password = Read-Host pvkPassword
    # pvk2Pfx /pvk MyKey.pvk /pi $password /spc MyKey.cer /pfx MyKey.pfx
    Export-PfxCertificate -cert Cert:\LocalMachine\My\$thumbprint -FilePath MyKey.pfx -ProtectTo (whoami)
    
    Certutil -addStore TrustedPeople MyKey.cer
}