#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/spotprent-van-de-dag~b1551c3b/ `
| Select-Object -ExpandProperty Content `
| pup '.artstyle__image attr{data-original}' --plain `
| Select-Object -First 10 `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_ `
        -Title ('Spotprent {0:dddd d MMMM yyyy}' -f (Get-Date)) `
        -Message 'Spotprent' `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -ApplicationToken aRkTUg5jtr9pSDQBPYwPN9X5dP2mHB `
        -ImageUrl $_ 
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