#!/usr/bin/env pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri 'https://www.driemond.info/dorpskrant/'
| Select-Object -Expand Content
| pup '.j-downloadDocument json{}' --plain
| jq '[.[]|{message:.children[1].children[0].text, link:.children[1].children[2].children[2].children[0].href}]'
| ConvertFrom-Json
| ForEach-Object {
    $Url = "https://driemond.info$($($_.link))"

    Send-KibitzrNotification `
        -Url $Url `
        -UniqueID $Url `
        -ApplicationToken a53g88zpsxd8srdx5ufzu9aq1w73gd `
        -Recipient gd3q14vf9sq3nhj7tqt7icrqpojwcv `
        -Title $_.message `
        -Message $Url `
        -TableName dorpskrant
}