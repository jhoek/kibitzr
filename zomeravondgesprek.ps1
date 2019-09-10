#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.nrc.nl/dossier/zomeravondgesprek/ `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item a attr{href}' --plain `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    $DateText = (($Url -split '/')[4..6]) -join '-'
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = ($Content | pup 'h1[data-flowtype="headline"] text{}' --plain)
    $Body = ($Content | pup 'div.content p text{}' --plain) -join ' '
    $Date = [DateTime]::ParseExact($DateText, 'yyyy-MM-dd', $null)

    Save-EntryToAirTable -TableName zomeravondgesprek -Url $Url -Date $Date -Title "Zomeravondgesprek: $Title" -Body $Body
}