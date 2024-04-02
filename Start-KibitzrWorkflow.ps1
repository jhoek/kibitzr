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
    git pull

    Update-RssFeed -Source { Get-BertKeizer } -Title 'Bert Keizer' -Link 'https://www.trouw.nl/auteur/bert-keizer' -Destination './data/bertkeizer.xml'
    Update-RssFeed -Source { Get-TeunVanDeKeuken } -Title 'Teun van de Keuken' -Link 'https://www.volkskrant.nl/auteur/teun-van-de-keuken' -Destination './data/teunvandekeuken.xml'
    Update-RssFeed -Source { Get-SylviaWitteman } -Title 'Sylvia Witteman' -Link 'https://www.volkskrant.nl/auteur/Sylvia%20Witteman' -Destination './data/sylviawitteman.xml'
    Update-RssFeed -Source { Get-EvaHoeke } -Title 'Eva Hoeke' -Link 'https://www.volkskrant.nl/auteur/eva-hoeke' -Destination './data/evahoeke.xml'
    Update-RssFeed -Source { Get-IonicaSmeets } -Title 'Ionica Smeets' -Link 'https://www.volkskrant.nl/auteur/ionica-smeets' -Destination './data/ionicasmeets.xml'
    Update-RssFeed -Source { Get-ThomasVanLuyn } -Title 'Thomas van Luyn' -Link 'https://www.volkskrant.nl/auteur/thomas-van-luyn' -Destination './data/thomasvanluyn.xml'

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
