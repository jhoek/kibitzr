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
    Update-RssFeed -Source { Get-CorineKoole } -Title 'Corine Koole' -Link 'https://www.volkskrant.nl/auteur/corine-koole' -Destination './data/corinekoole.xml'
    Update-RssFeed -Source { Get-Gummbah } -Title 'Gummbah' -Link 'https://www.volkskrant.nl/cartoons/gummbah~b91c34a2/' -Destination './data/gummbah.xml' -Cartoon
    Update-RssFeed -Source { Get-Collignon } -Title 'Collignon' -Link 'https://www.volkskrant.nl/cartoons/collignon~b2752a21/' -Destination './data/collignon.xml' -Cartoon
    Update-RssFeed -Source { Get-FrankHeinen } -Title 'Frank Heinen' -Link 'https://www.volkskrant.nl/auteur/frank-heinen' -Destination './data/frankheinen.xm'l
}
finally
{
    Pop-Location
}
