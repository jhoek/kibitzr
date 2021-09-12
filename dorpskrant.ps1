#!/usr/bin/env pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
. $PSScriptRoot/Test-PreviouslyUnseen.ps1

Invoke-WebRequest -Uri 'https://www.driemond.info/dorpskrant/'
| Select-Object -ExpandProperty Links
| Select-Object -ExpandProperty href -Unique
| Where-Object { $_ -match "/app/download/\d+/([^?]+)\?" }
| Where-Object { $_ | Test-PreviouslyUnseen -Path ~/dorpskrant.seen }
| ForEach-Object { Invoke-WebRequest -Uri "https://www.driemond.info$_" -OutFile "/shared/$($Matches[1])" }