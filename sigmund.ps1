#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri 'https://www.volkskrant.nl/columns-opinie/sigmund~q8c5108e/' `
| Select-Object -ExpandProperty Images
| Select-Object -Skip 1
| ForEach-Object {
    $Date = [DateTime]::ParseExact($_.'data-title', "d MMMM yyyy", $DutchCulture)

    Send-KibitzrNotification `
        -Url $_.src `
        -ApplicationToken awa6xfkn3jg93wsthnnb7e37v3j92t `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message ('{0:dddd d MMMM yyyy}' -f $Date) `
        -ImageUrl $_.src
}