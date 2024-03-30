#!/usr/bin/env pwsh

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
        [string]$Destination
    )

    (& $Source)
    | Select-Object -First 10
    | ForEach-Object {
        New-RssFeedItem `
            -ID $_.Url `
            -Title $_.Title `
            -Description (($_.Body | ForEach-Object { $_.Trim() } | Where-Object { $_ } | ForEach-Object { "<p>$($_)</p>" }) -join "`n") `
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
    Update-RssFeed -Source { Get-BertKeizer } -Title 'Bert Keizer' -Link 'https://www.trouw.nl/auteur/bert-keizer' -Destination './data/bertkeizer.xml'
    Update-RssFeed -Source { Get-TeunVanDeKeuken } -Title 'Teun van de Keuken' -Link 'https://www.volkskrant.nl/auteur/teun-van-de-keuken' -Destination './data/teunvandekeuken.xml'
    Update-RssFeed -Source { Get-SylviaWitteman } -Title 'Sylvia Witteman' -Link 'https://www.volkskrant.nl/auteur/Sylvia%20Witteman' -Destination './data/sylviawitteman.xml'
}
finally
{
    Pop-Location
}
