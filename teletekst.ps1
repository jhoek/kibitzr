#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
Import-Module UncommonSense.Teletekst

function ConvertTo-Base64
{
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Value
    )

    [System.Convert]::ToBase64String(
        [System.Text.Encoding]::Unicode.GetBytes($Value)
    )
}

Get-TeletekstNews -Type Domestic, Foreign `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_.Link `
        -UniqueID (ConvertTo-Base64 -Value "$($_.Title) - $($_.Content)") `
        -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
        -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
        -Title $_.Title `
        -Message $_.Content
}

# Locale cache in json-formaat
# Bij aanroep eerst oude berichten (> 2 dgn?) opkuisen
# Eerst op hash vergelijken met cached item? gelijk = exit
# Dan als titel *en* body beide niet similar aan cached items: notificatie
# Nieuwe item cachen