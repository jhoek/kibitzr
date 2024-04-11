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
}

Push-Location ~/GitHub/kibitzr

try
{
    git pull

    Update-RssFeed -Source { Get-BertKeizer } -Title 'Bert Keizer' -Link 'https://www.trouw.nl/auteur/bert-keizer' -Destination './data/bertkeizer.xml'
    Update-RssFeed -Source { Get-TienGeboden } -Title 'Tien Geboden' -Link 'https://www.trouw.nl/dossier-tien-geboden' -Destination './data/tiengeboden.xml'
    Update-RssFeed -Source { Get-TeunVanDeKeuken } -Title 'Teun van de Keuken' -Link 'https://www.volkskrant.nl/auteur/teun-van-de-keuken' -Destination './data/teunvandekeuken.xml'
    Update-RssFeed -Source { Get-SylviaWitteman } -Title 'Sylvia Witteman' -Link 'https://www.volkskrant.nl/auteur/Sylvia%20Witteman' -Destination './data/sylviawitteman.xml'
    Update-RssFeed -Source { Get-EvaHoeke } -Title 'Eva Hoeke' -Link 'https://www.volkskrant.nl/auteur/eva-hoeke' -Destination './data/evahoeke.xml'
    Update-RssFeed -Source { Get-IonicaSmeets } -Title 'Ionica Smeets' -Link 'https://www.volkskrant.nl/auteur/ionica-smeets' -Destination './data/ionicasmeets.xml'
    Update-RssFeed -Source { Get-ThomasVanLuyn } -Title 'Thomas van Luyn' -Link 'https://www.volkskrant.nl/auteur/thomas-van-luyn' -Destination './data/thomasvanluyn.xml'
    Update-RssFeed -Source { Get-JipVanDenToorn } -Title 'Jip van den Toorn' -Link 'https://www.volkskrant.nl/cartoons/jip-van-den-toorn~bbe9994c/' -Destination './data/jipvandentoorn.xml'
    Update-RssFeed -Source { Get-BasVanDerSchot } -Title 'Bas van der Schot' -Link 'https://www.volkskrant.nl/cartoons/bas-van-der-schot~b31a8d34/' -Destination './data/basvanderschot.xml'
    Update-RssFeed -Source { Get-JasperVanKuijk } -Title 'Jasper van Kuijk' -Link 'https://www.volkskrant.nl/auteur/jasper-van-kuijk' -Destination './data/jaspervankuijk'

    # git config user.name github-actions
    # git config user.email github-actions@github.com
    git add .
    git commit -m "generated" || Write-Output "No changes to commit"
    git push
}
finally
{
    Pop-Location
}
