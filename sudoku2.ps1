#!/usr/bin/env pwsh

Get-Sudoku
| Select-Object -First 1
| ForEach-Object {
    Invoke-WebRequest `
        -Uri $_.Body `
        -OutFile "~/Dropbox/Public/Sudoku $($_.Date.ToString('yyyy-MM-dd')).png" }