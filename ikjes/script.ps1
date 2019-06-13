$ProgressPreference = 'SilentlyContinue'
$SmartSingleQuotes = '[\u2019\u2018\u201A]'
$SmartDoubleQuotes = '[\u201C\u201D\u201E]'

Invoke-WebRequest -Uri https://www.nrc.nl/rubriek/ikje `
| Select-Object -ExpandProperty Content `
| pup 'a.nmt-item__link attr{href}' `
| Select-Object -First 10 `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    $DateText = (($Url -split '/')[4..6]) -join '-'
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = ($Content | pup 'h1[data-flowtype="headline"] text{}')
$Body = ((($Content | pup 'div.content p text{}') -join ' ') -replace $SmartSingleQuotes, '''') -replace $SmartDoubleQuotes, '"'
$Date = [DateTime]::ParseExact($DateText, 'yyyy-MM-dd', $null)

if (-not (Test-AirTableRecord -TableName ikjes -FieldName Url -Value $Url))
{
    New-AirTableRecord `
        -TableName ikjes `
        -Fields @{ Url = $Url; Title = $Title; Body = $Body; Date = $Date }
}
else
{
    Write-Verbose "An AirTable record with Url $Url already exists; skipping."
}
}