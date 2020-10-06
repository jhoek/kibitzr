#!/usr/bin/env pwsh

$BaseName = 'appijTztM8utviyTC'
$TableName = 'Fund Price'

Get-TriodosFundPrice |
    ForEach-Object {
        $Fields = @{
            Date  = $_.Date
            Fund  = $_.Fund
            Price = $_.Price
        }

        New-AirTableRecord `
            -BaseName $BaseName `
            -TableName $TableName `
            -Fields $Fields
    }