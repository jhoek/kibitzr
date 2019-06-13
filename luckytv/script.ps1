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

    if (-not (Test-AirTableRecord -TableName luckytv -FieldName Url -Value $Url))
    {
        New-AirTableRecord `
            -TableName luckytv `
            -Fields @{ Url = $Url; Title = $Title; Date = $Date; ThumbNail = $ThumbNail }
    }
    else 
    {
        Write-Verbose "An AirTable record with Url $Url already exists; skipping."
    }    
}