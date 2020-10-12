#!/usr/bin/env pwsh

$BaseName = 'appijTztM8utviyTC'
$TableName = 'Fund Price'

Get-TriodosFundPrice |
    ForEach-Object {
        $Fields = [Ordered]@{
            Date  = $_.Date
            Fund  = $_.Fund
            Price = $_.Price
        }

        New-AirTableRecord `
            -BaseName $BaseName `
            -TableName $TableName `
            -Fields $Fields
    }

Find-AirTableRecord `
    -BaseName $BaseName `
    -TableName $TableName `
    -MaxRecords 3 `
    -Filter 'Fund="Triodos Global Equities Impact Fund"'