$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri 'http://www.luckytv.nl/afleveringen/' `
    | Select-Object -ExpandProperty Content `
    | pup --plain 'article.video div json{}' `
    | ConvertFrom-Json -AsHashtable `
    | ForEach-Object { $_.GetEnumerator() } `
    | ForEach-Object {
    $Link = $_['children'][0]
    $MetaData = $_['children'][1]

    $Title = $MetaData['children'][0]['children'][0].text
    $DateElements = ($MetaData['children'][1].text -split ' ')
    $DateText = "$($DateElements[1]) $($DateElements[2]). $($DateElements[3])"
    $Date = [DateTime]::ParseExact($DateText, 'd MMM yyyy', $DutchCulture)
    $Url = $Link.href
    $ThumbNail = $Link['children'][0].src

    $Payload = (@{fields = @{ Url = $Url; Title = $Title; Date = $Date; ThumbNail = $ThumbNail }} | ConvertTo-Json -Depth 5)
    Write-Verbose $Payload

    Invoke-RestMethod `
        -Method POST `
        -Uri 'https://api.airtable.com/v0/appB4Jzod47gLXUVE/luckytv' `
        -ContentType 'application/json' `
        -Headers @{'Authorization' = "Bearer $($env:AirTableApiKey)"} `
        -Body $Payload
}