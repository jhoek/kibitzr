#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

$Content = Invoke-WebRequest -Uri 'https://www.volkskrant.nl/cultuur-media/jip-van-den-toorn~b2e00b99/' `
| Select-Object -ExpandProperty Content

$Dates = $Content
| pup '.artstyle__main--container h3 text{}' --plain
| ForEach-Object { $_.Trim() }
| Where-Object { $_ }
| ForEach-Object { [DateTime]::ParseExact($_, "d MMMM yyyy", $DutchCulture) }

$Images = $Content
| pup '.artstyle__main--container img attr{src}'

$NoOfItems = ($Dates.Count), ($Images.Count) | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum

0..($NoOfItems - 1) | ForEach-Object {
    Send-KibitzrNotification `
        -Url $Images[$_] `
        -ApplicationToken ayu9cm9t3f1satguceo6q5ifje821y `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message ('{0:dddd d MMMM yyyy}' -f $Dates[$_]) `
        -ImageUrl $Images[$_]
}