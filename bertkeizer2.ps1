#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri 'https://www.medischcontact.nl/opinie/blogs-columns/bloggers-columnisten/bloggercolumnist/bert-keizer.htm' `
| Select-Object -ExpandProperty Content `
| pup '.publication_title a attr{href}' --plain `
| ForEach-Object {
    $Url = 'https://www.medischcontact.nl{0}' -f $_
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = $Content | pup 'h1 text{}' --plain
    $Body = $Content | pup '.articleDetail_content p text{}' --plain
    $DateText = (($Content | pup '.articleDetail_header .author_date text{}' --plain)[1]).Trim()
    $Date = [datetime]::ParseExact($DateText, 'dd MMMM yyyy', $DutchCulture)

    Save-EntryToAirTable -Url $Url -Title "Bert Keizer: $Title" -Body $Body -Date $Date -Verbose -Table Mail
}