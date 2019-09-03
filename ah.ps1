Find-AirTableRecord -TableName ah `
| ForEach-Object { Remove-AirTableRecord -TableName ah -RecordID $_.AirTableRecordID }

Get-AHStore -ID 1844, 1083, 1541, 1855 `
| ForEach-Object {
    $Store = "$($_.City), $($_.Street)"

    $_.OpeningHours `
    | ForEach-Object {
        $Date = $_.From.Date
        $From = $_.From.ToString('HH:mm')
        $To = $_.To.ToString('HH:mm')
        $OpeningHours = "$From..$To"

        $Fields = @{
            Store        = $Store
            Date         = $Date
            OpeningHours = $OpeningHours
        }

        New-AirTableRecord `
            -TableName ah `
            -Fields $Fields `
    }
}