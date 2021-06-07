#!/usr/bin/pwsh

. $PSScriptRoot/Send-KibitzrNotification.ps1

$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri 'https://dirkjan.nl' 
| Select-Object -ExpandProperty Content
| pup '.post-navigation__day attr{href}'
| ForEach-Object { 
    $Date = (($_ -split '/')[4] -split '_')[0]; $_ 
    
    Invoke-WebRequest -Uri $_ 
    | Select-Object -ExpandProperty Content 
    | pup '.cartoon img attr{src}'
    | ForEach-Object {
        Send-KibitzrNotification `
            -Url $_ `
            -ApplicationToken arb2a6e1c5eomx796jbhkfmijeqrbq `
            -Recipient gnkfssw1q1qp4pst9x3iu4rkrfzqi9 `
            -Message ([DateTime]::ParseExact($Date, 'yyyyMMdd', $DutchCulture)).ToShortDateString() `
            -ImageUrl $_        
    }
}