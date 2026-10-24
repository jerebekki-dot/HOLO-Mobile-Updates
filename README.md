# HOLO Mobile v0.6.1.2 – diagnostiikkapaketin lataus

Yksittäinen 153 Mt:n paketti ei avaudu Codexin tiedostoesikatselussa. Paketti on
siksi jaettu neljään alle 40 MiB:n osaan. Tämä on lukutilainen diagnostiikkaversio,
ei v0.6.1.3-tunnistuskorjaus.

Lataa samaan tyhjään Windows-kansioon seuraavat viisi tiedostoa:

1. [osa 1](HOLO-Mobile-v0.6.1.2-diagnostics-kit-part1.bin)
2. [osa 2](HOLO-Mobile-v0.6.1.2-diagnostics-kit-part2.bin)
3. [osa 3](HOLO-Mobile-v0.6.1.2-diagnostics-kit-part3.bin)
4. [osa 4](HOLO-Mobile-v0.6.1.2-diagnostics-kit-part4.bin)
5. [KOKOA_DIAGNOSTIIKKAPAKETTI.ps1](KOKOA_DIAGNOSTIIKKAPAKETTI.ps1)

GitHubin tiedostosivulla paina **Download raw file**. Älä avaa `.bin`-osia
WinRARilla.

Avaa PowerShell latauskansiossa ja suorita:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Unblock-File -LiteralPath .\KOKOA_DIAGNOSTIIKKAPAKETTI.ps1
.\KOKOA_DIAGNOSTIIKKAPAKETTI.ps1
```

Skripti tarkistaa jokaisen osan koon ja SHA-256-tarkistussumman ennen kokoamista.
Valmis tiedosto on `HOLO-Mobile-v0.6.1.2-diagnostics-kit.zip`. Sen odotettu
SHA-256 on:

```text
3804d76c053386597a4f1cd3cf1bee64dcd4794f14d846f10b5c049279be3720
```

Pura valmis ZIP ja jatka sen sisältämästä `ALOITA_TASTA.txt`-ohjeesta.

Lähdekoodi: haara `codex/holo-mobile-v0.6.1.3-diagnostics`, commit `a78e546`.
