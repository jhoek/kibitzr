#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

$Elements = Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/de-wereld-van-anton-dingeman~b21b94dc/ `
| Select-Object -ExpandProperty Content `
| pup 'article section.artstyle__main--container json{}' --plain `
| ConvertFrom-Json -Depth 10 `
| ForEach-Object { $_.children } `
| Select-Object -First 10

while ($Elements)
{
    $First, $Second, $Elements = $Elements
    $DateText = $First.Text
    $Date = $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy', $DutchCulture)
    $Title = "Anton Dingeman $DateText"
    $Url = $Second.children.'data-original' 

    Save-EntryToAirTable -TableName antondingeman -Url $Url -Title $Title -Body $Url -Date $Date
}