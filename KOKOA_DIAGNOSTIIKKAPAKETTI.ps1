param(
    [string]$OutputPath = (Join-Path $PSScriptRoot 'HOLO-Mobile-v0.6.1.2-diagnostics-kit.zip')
)

$ErrorActionPreference = 'Stop'
$ExpectedBytes = 160028372
$ExpectedSha256 = '3804d76c053386597a4f1cd3cf1bee64dcd4794f14d846f10b5c049279be3720'
$OutputPath = [IO.Path]::GetFullPath($OutputPath)
$Parts = @(
    @{ Name = 'HOLO-Mobile-v0.6.1.2-diagnostics-kit-part1.bin'; Bytes = 41943040; Sha256 = '46119f730e218743dfa619bd27a5f8288d9f6b2c8840c93bf99bedda6deed8ad' }
    @{ Name = 'HOLO-Mobile-v0.6.1.2-diagnostics-kit-part2.bin'; Bytes = 41943040; Sha256 = '7d7595d43374bb7b7c8cfd01cbb63da74135bc2f14c7253a4756581e283bb8a6' }
    @{ Name = 'HOLO-Mobile-v0.6.1.2-diagnostics-kit-part3.bin'; Bytes = 41943040; Sha256 = 'c2143b5c72a4200dc3042a439857c300889ed8633cdb95dfeaa5377114699d5d' }
    @{ Name = 'HOLO-Mobile-v0.6.1.2-diagnostics-kit-part4.bin'; Bytes = 34199252; Sha256 = '8510d520936f472bf2974d0ce364ff6fadd34490a40102973ed301c3d90cddd6' }
)

if (Test-Path -LiteralPath $OutputPath) {
    if ((Test-Path -LiteralPath $OutputPath -PathType Leaf) -and
        (Get-Item -LiteralPath $OutputPath).Length -eq $ExpectedBytes -and
        (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash -eq $ExpectedSha256) {
        Write-Host "Diagnostiikkapaketti on jo valmis ja SHA-256 tarkistettu: $OutputPath"
        return
    }
    throw "Tulostiedosto on jo olemassa ja eroaa oikeasta paketista: $OutputPath. Tiedostoa ei muutettu."
}

foreach ($Part in $Parts) {
    $Path = Join-Path $PSScriptRoot $Part.Name
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Paketin osa puuttuu: $($Part.Name). Lataa kaikki nelja osaa samaan kansioon."
    }
    if ((Get-Item -LiteralPath $Path).Length -ne $Part.Bytes -or
        (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ne $Part.Sha256) {
        throw "Paketin osa ei vastaa tarkistussummaa: $($Part.Name). Lataa kyseinen osa uudelleen."
    }
}

$Temporary = $OutputPath + '.assembling-' + [guid]::NewGuid().ToString('N')
try {
    $Destination = [IO.File]::Open($Temporary, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write)
    try {
        foreach ($Part in $Parts) {
            $Source = [IO.File]::OpenRead((Join-Path $PSScriptRoot $Part.Name))
            try { $Source.CopyTo($Destination) } finally { $Source.Dispose() }
        }
    } finally { $Destination.Dispose() }
    if ((Get-Item -LiteralPath $Temporary).Length -ne $ExpectedBytes -or
        (Get-FileHash -LiteralPath $Temporary -Algorithm SHA256).Hash -ne $ExpectedSha256) {
        throw 'Kootun paketin koko tai SHA-256 ei tasmaa. Pakettia ei oteta kayttoon.'
    }
    [IO.File]::Move($Temporary, $OutputPath)
} finally {
    if (Test-Path -LiteralPath $Temporary) {
        Remove-Item -LiteralPath $Temporary -ErrorAction SilentlyContinue
    }
}

Write-Host "Valmis diagnostiikkapaketti: $OutputPath"
Write-Host "SHA-256: $ExpectedSha256"
Write-Host 'Pura ZIP ja avaa ALOITA_TASTA.txt.'
