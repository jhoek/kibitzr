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
    $Payload = (@{fields = @{ Url = $Url; Title = $Title; Body = $Body; Date = $Date }} | ConvertTo-Json -Depth 5)

    Write-Verbose $Payload

    Invoke-RestMethod `
        -Method POST `
        -Uri 'https://api.airtable.com/v0/appB4Jzod47gLXUVE/ikjes' `
        -ContentType 'application/json' `
        -Headers @{'Authorization' = "Bearer $($env:AirTableApiKey)"} `
        -Body $Payload
}