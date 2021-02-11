#!/usr/bin/pwsh

. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri "https://www.evajinek.nl/node-in-term/ajax/252550/0" -SkipHttpErrorCheck
| Where-Object StatusCode -eq 200
| Select-Object -ExpandProperty Content
| pup 'a attr{href}'
| ForEach-Object {
    $Content =
    Invoke-WebRequest -Uri $_ -SkipHttpErrorCheck
    | Where-Object StatusCode -eq 200
    | Select-Object -ExpandProperty Content

$Title = $Content | pup 'h1 text{}'
$DateTime = ($Content | pup '.node-meta-attributes__time text{}') | Select-Object -First 1

Send-KibitzrNotification `
    -Url $_ `
    -ApplicationToken afbzfvwfwjq5ritp51kw26sivnm1jj `
    -Recipient g5ehi5433y6s6sb58xf25hzwsmqxy3 `
    -Title $Title `
    -Message $DateTime
}