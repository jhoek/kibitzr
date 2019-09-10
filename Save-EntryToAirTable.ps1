function Save-EntryToAirTable
{
    param
    (
        [string]$TableName,
        [string]$Url,
        [DateTime]$Date,
        [string]$Title,
        [string]$Body
    )

    $SmartSingleQuotes = '[\u2019\u2018\u201A]'
    $SmartDoubleQuotes = '[\u201C\u201D\u201E]'

    if (-not (Test-AirTableRecord -TableName kibitzr -FieldName Url -Value $Url))
    {
        $Body = ($Body -replace $SmartSingleQuotes, '''') -replace $SmartDoubleQuotes, '"'

        New-AirTableRecord `
            -TableName kibitzr `
            -Fields @{ Source = $TableName; Url = $Url; Title = $Title; Body = $Body; Date = $Date }
    }
    else
    {
        Write-Verbose "An AirTable record with Url '$Url' already exists in table $TableName; skipping."
    }
}