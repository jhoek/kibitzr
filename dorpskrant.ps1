#!/usr/bin/env pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri 'https://www.driemond.info/dorpskrant/'
| Select-Object -ExpandProperty Links
| Select-Object -ExpandProperty href -Unique
| Where-Object { $_ -match "/app/download/\d+/([^?]+)\?" }
| Select-Object -First 1
| ForEach-Object { Invoke-WebRequest -Uri "https://www.driemond.info$_" -OutFile "/shared/$($Matches[1])" }