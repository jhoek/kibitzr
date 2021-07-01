#!/usr/bin/pwsh

. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri https://www.parool.nl/ps/dirkjan~b8731189/
| Select-Object -ExpandProperty Content
| pup 'figure json{}' --plain
| jq '[ .[].children[0].children[2] | { date: .\"data-title\", url: .\"data-original\" } ]'
| ConvertFrom-Json
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_.url `
        -ApplicationToken arb2a6e1c5eomx796jbhkfmijeqrbq `
        -Recipient gnkfssw1q1qp4pst9x3iu4rkrfzqi9 `
        -Message "$($_.date)" `
        -ImageUrl $_.url
}