Get-AHStore -ID 1844 `
| ForEach-Object {
    $Description = "$($_.City), $($_.Street)"

    Find-AirTableRecord -TableName ah -Fields ID -Filter "{Description}='$Description'" -Verbose

}