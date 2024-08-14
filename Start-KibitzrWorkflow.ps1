#!/usr/local/microsoft/powershell/7/pwsh

function Update-RssFeed
{
    param
    (
        [Parameter(Mandatory)]
        [scriptblock]$Source,

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Link,

        [Parameter(Mandatory)]
        [string]$Destination,

        [switch]$Cartoon
    )

    (& $Source)
    | Select-Object -First 10
    | ForEach-Object {
        $Description =
        $Cartoon ?
        "<img src='$($_.Body)'/>" :
            (($_.Body | ForEach-Object { $_.Trim() } | Where-Object { $_ } | ForEach-Object { "<p>$($_)</p>" }) -join "`n")

        New-RssFeedItem `
            -ID $_.Url `
            -Title $_.Title `
            -Description $Description `
            -PubDate $_.Date
    }
    | New-RssFeed `
        -Title $Title `
        -Link $Link `
        -Description $Title
    | Set-Content -Path $Destination

    git pull
    git add .
    git commit -m "generated" || Write-Output "No changes to commit"
    git push
}

Push-Location ~/GitHub/kibitzr
try
{
    Update-RssFeed -Source { Get-TienGeboden } -Title 'Tien Geboden' -Link 'https://www.trouw.nl/dossier-tien-geboden' -Destination './data/tiengeboden.xml'
    Update-RssFeed -Source { Get-SylviaWitteman } -Title 'Sylvia Witteman' -Link 'https://www.volkskrant.nl/auteur/Sylvia%20Witteman' -Destination './data/sylviawitteman.xml'
    Update-RssFeed -Source { Get-EvaHoeke } -Title 'Eva Hoeke' -Link 'https://www.volkskrant.nl/auteur/eva-hoeke' -Destination './data/evahoeke.xml'
    Update-RssFeed -Source { Get-IonicaSmeets } -Title 'Ionica Smeets' -Link 'https://www.volkskrant.nl/auteur/ionica-smeets' -Destination './data/ionicasmeets.xml'
    Update-RssFeed -Source { Get-ThomasVanLuyn } -Title 'Thomas van Luyn' -Link 'https://www.volkskrant.nl/auteur/thomas-van-luyn' -Destination './data/thomasvanluyn.xml'
    Update-RssFeed -Source { Get-JipVanDenToorn } -Title 'Jip van den Toorn' -Link 'https://www.volkskrant.nl/cartoons/jip-van-den-toorn~bbe9994c/' -Destination './data/jipvandentoorn.xml' -Cartoon
    Update-RssFeed -Source { Get-BasVanDerSchot } -Title 'Bas van der Schot' -Link 'https://www.volkskrant.nl/cartoons/bas-van-der-schot~b31a8d34/' -Destination './data/basvanderschot.xml' -Cartoon
    Update-RssFeed -Source { Get-JasperVanKuijk } -Title 'Jasper van Kuijk' -Link 'https://www.volkskrant.nl/auteur/jasper-van-kuijk' -Destination './data/jaspervankuijk.xml'
    Update-RssFeed -Source { Get-HeinDeKort } -Title 'Hein de Kort' -Link 'https://www.parool.nl' -Destination './data/heindekort.xml' -Cartoon
    Update-RssFeed -Source { Get-DirkJan } -Title 'Dirk-Jan' -Link 'https://www.parool.nl' -Destination './data/dirkjan.xml' -Cartoon
    Update-RssFeed -Source { Get-SanderSchimmelpenninck } -Title 'Sander Schimmelpenninck' -Link 'https://www.volkskrant.nl/auteur/sander-schimmelpenninck' -Destination './data/sanderschimmelpenninck.xml'
    Update-RssFeed -Source { Get-Sigmund } -Title 'Sigmund' -Link 'https://www.volkskrant.nl/cartoons/sigmund~b82ba1fa5/' -Destination './data/sigmund.xml' -Cartoon
    Update-RssFeed -Source { Get-RoosSchlikker } -Title 'Roos Schlikker' -Link 'https://www.parool.nl/auteur/roos-schlikker' -Destination './data/roosschlikker.xml'
    Update-RssFeed -Source { Get-Spotprent } -Title 'Spotprent' -Link 'https://www.trouw.nl/achterpagina/spotprenten~bc9b7dca/' -Destination './data/spotprent.xml' -Cartoon
    Update-RssFeed -Source { Get-CorineKoole } -Title 'Corine Koole' -Link 'https://www.volkskrant.nl/auteur/corine-koole' -Destination './data/corinekoole.xml'
    Update-RssFeed -Source { Get-Gummbah } -Title 'Gummbah' -Link 'https://www.volkskrant.nl/cartoons/gummbah~b91c34a2/' -Destination './data/gummbah.xml' -Cartoon
    Update-RssFeed -Source { Get-Collignon } -Title 'Collignon' -Link 'https://www.volkskrant.nl/cartoons/collignon~b2752a21/' -Destination './data/collignon.xml' -Cartoon
    Update-RssFeed -Source { Get-FrankHeinen } -Title 'Frank Heinen' -Link 'https://www.volkskrant.nl/auteur/frank-heinen' -Destination './data/frankheinen.xm'l
}
finally
{
    Pop-Location
}
