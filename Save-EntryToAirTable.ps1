function Save-EntryToAirTable
{
    param
    (
        [string]$Url,
        [DateTime]$Date,
        [string]$Title,
        [string]$Body
    )

    $SmartSingleQuotes = '[\u2019\u2018\u201A]'
    $SmartDoubleQuotes = '[\u201C\u201D\u201E]'

    if (-not (Test-AirTableRecord -TableName rss -FieldName Url -Value $Url))
    {
        $Body = ($Body -replace $SmartSingleQuotes, '''') -replace $SmartDoubleQuotes, '"'

        New-AirTableRecord `
            -TableName rss `
            -Fields @{ Url = $Url; Title = $Title; Body = $Body; Date = $Date }
    }
    else
    {
        Write-Warning "Entry for '$Url' already exists in table 'rss'."
    }
}