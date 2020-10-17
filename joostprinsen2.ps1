. ./Save-EntryToAirTable
$DutchCulture = [cultureinfo]::GetCultureInfo('nl-NL')

#@('https://www.haarlemsdagblad.nl/cnt/dmf20200527_71432096/een-blauwdruk-voor-het-dagelijks-leven-in-2025-column-joost-prinsen')
& ./joostprinsen1.ps1 
| ForEach-Object { Write-Verbose "$_"; $_ }
| ForEach-Object { Invoke-WebRequest $_ }
| Select-Object -ExpandProperty Content
| pup 'script json{}'
| ConvertFrom-Json
| Where-Object text -Like 'window`["__PRE*'
| Select-Object -First 1 -ExpandProperty Text
| ForEach-Object { $_ -replace '^window\["__PRELOADED_STATE_GRAPH__[^"]*"\] = ', '' }
| jq '[.[]][0] | { title: .title, intro: ([.intro.json[].p]|join(\" \")), body: ([.body.json[].p]|join(\" \"))}'
# | ConvertFrom-Json
# | ForEach-Object {
#     $Url -match 'DMF(\d{8})' | Out-Null
#     $Date = [DateTime]::ParseExact($Matches[1], 'yyyyMMdd', $DutchCulture)

#     Save-EntryToAirTable `
#         -Url $Url `
#         -Date $Date `
#         -Title $_.Title `
#         -Body @($_.Intro, $_.Body) -join ' ' `
#         -TableName mail
# }