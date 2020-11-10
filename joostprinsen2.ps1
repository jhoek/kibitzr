#!/usr/bin/env pwsh
param(
    [Parameter(Mandatory, ValueFromPipeline = $true)]
    [string]$Url
)

begin
{
    . ./Save-EntryToAirTable
    $DutchCulture = [cultureinfo]::GetCultureInfo('nl-NL')
}

process
{
    Invoke-WebRequest $Url
    | Select-Object -ExpandProperty Content
    | pup 'script json{}'
    | ConvertFrom-Json
    | Where-Object text -Like 'window`["__PRE*'
    | Select-Object -First 1 -ExpandProperty Text
    | ForEach-Object { $_ -replace '^window\["__PRELOADED_STATE_GRAPH__[^"]*"\] = ', '' }
    | jq '[.[]][0] | { title: .title, intro: ([.intro.json[].p]|join(\" \")), body: ([.body.json[].p]|join(\" \"))}'
    | ConvertFrom-Json
    | ForEach-Object {
        $Url -match 'DMF(\d{8})' | Out-Null
        $Date = [DateTime]::ParseExact($Matches[1], 'yyyyMMdd', $DutchCulture)

        Save-EntryToAirTable `
            -Url $Url `
            -Date $Date `
            -Title $_.Title `
            -Body @($_.Intro, $_.Body) -join ' ' `
            -TableName mail
    }
}