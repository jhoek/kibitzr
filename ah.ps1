Get-AHStore -ID 1844, 1083, 1541, 1855 `
| ForEach-Object {
    $Description = "$($_.City), $($_.Street)"
    $_.OpeningHours `
    | ForEach-Object {
        $Fields = @{
            FromTime    = $_.From.ToUniversalTime()
            ToTime      = $_.To.ToUniversalTime()
            Description = $Description
        }

        New-AirTableRecord `
            -TableName ah `
            -Fields $Fields `
    }
}