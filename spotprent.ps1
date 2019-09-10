#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/spotprent-van-de-dag~b1551c3b/ `
| Select-Object -ExpandProperty Content `
| pup '.artstyle__image attr{data-original}' --plain `
| Select-Object -First 10 `
| ForEach-Object {
    Save-EntryToAirTable -TableName spotprent -Url $_ -Title ('Spotprent {0:dddd d MMMM yyyy}' -f (Get-Date)) -Body $_ -Date (Get-Date)
}

# while ($Elements)
# {
#     $First, $Second, $Elements = $Elements
#     $First.Text
#     $Second.Text
#     $DateText = $First.Text
#     $Date = $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy', $DutchCulture)
#     $Title = "Spotprent van de dag $DateText"
#     $Url = $Second.children.'data-original'

#     # $Title
#     # $url
#     # $Date

#     #
# }