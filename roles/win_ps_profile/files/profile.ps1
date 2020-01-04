$Path = "C:\Users\tmcphill\.ps_profile"
Get-ChildItem -Path $Path -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}
