#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

$Content = Invoke-WebRequest -Uri 'https://www.volkskrant.nl/cultuur-media/jip-van-den-toorn~b2e00b99/' `
| Select-Object -ExpandProperty Content

$Dates = $Content
| pup '.artstyle__main--container h3 text{}' --plain
| ForEach-Object { $_.Trim() }
| Where-Object { $_ }
| ForEach-Object { "***$_***" }

$Images = $Content
| pup '.artstyle__main--container img attr{src}'

$Dates.Count
$IMages.Count

# | Select-Object -ExpandProperty href `
# | Where-Object { $_ -like '/nieuws/*' } `
# | ForEach-Object { "https://www.nrc.nl$($_)" } `
# | ForEach-Object {
#     $DateElements = ($_ -split '/')[4..6]
#     $Date = Get-Date -Year $DateElements[0] -Month $DateElements[1] -Day $DateElements[2]

#     $ImageUrl =
#         Invoke-WebRequest -Uri $_ `
#         | Select-Object -ExpandProperty Content `
#         | ForEach-Object { $_ | pup 'img attr{src}' --plain }

#     Send-KibitzrNotification `
#         -Url $_ `
#         -ApplicationToken a7sw8gciyp7mn9ddgi9wcmbd15yk73 `
#         -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
#         -Message ('{0:dddd d MMMM yyyy}' -f $Date) `
#         -ImageUrl $ImageUrl
# }