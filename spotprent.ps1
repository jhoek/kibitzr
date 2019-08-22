#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

$Elements = Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/spotprent-van-de-dag~b1551c3b/ `
| Select-Object -ExpandProperty Content `
| pup 'article section.artstyle__main--container json{}' --plain `
| ConvertFrom-Json -Depth 10 `
| ForEach-Object { $_.children } `
| Where-Object tag -in 'h3', 'figure'

while ($Elements)
{
    $First, $Second, $Elements = $Elements
    $First
    $Second
    $DateText = $First.Text
    $Date = $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy', $DutchCulture)
    $Title = "Spotprent van de dag $DateText"
    $Url = $Second.children.'data-original' 

    # $Title
    # $url
    # $Date

    #Save-EntryToAirTable -TableName antondingeman -Url $Url -Title $Title -Body $Url -Date $Date
}