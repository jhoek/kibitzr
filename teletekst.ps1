#!/usr/bin/pwsh
. $PSScriptRoot/Get-TextSimilarity.ps1
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

$CachedItems = @()
$AddToCache = @()

$Begin = {
    if (Test-Path -Path $PSScriptRoot/teletekst.json)
    {
        $CachedItems =
        Get-Content -Path $PSScriptRoot/teletekst.json
        | ConvertFrom-Json -Depth 10
        | Where-Object DateTime -GT (Get-Date).AddDays(-2)
}
}

$Process = {
    $CurrentItem = $_
    $Hash = (ConvertTo-Base64 -Value "$($CurrentItem.Title) - $($CurrentItem.Content)")

    if ($CachedItems | Where-Object Hash -EQ $Hash)
    {
        Write-Verbose "$($CurrentItem.Title) unchanged; skipping"
        exit
    }

    $AnySimilar = $CachedItems.Where{
        if ((Get-TextSimilarity $CurrentItem.Title $_.Title) -gt 0.7)
        {
            Write-Host "Title $($CurrentItem.Title) matches cached title $($_.Title)"
            return $_
        }

        if ((Get-TextSimilarity $CurrentItem.Content $_.Content) -gt 0.7)
        {
            Write-Host "Content $($CurrentItem.Content) matches cached content $($_.Content)"
            return $_
        }
    }

    if (-not($AnySimilar))
    {
        Send-PushoverNotification `
            -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
            -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
            -Title $CurrentItem.Title `
            -Message $CurrentItem.Content `
            -SupplementaryUrl $CurrentItem.Link
    }

    $AddToCache = $AddToCache + [PSCustomObject]@{
        Title    = $CurrentItem.Title
        Content  = $CurrentItem.Content
        Hash     = $Hash
        DateTime = (Get-Date).ToString('s')
    }
}

$End = {
    $CachedItems = $CachedItems + $AddToCache
    $CachedItems | ConvertTo-Json -Depth 10 | Set-Content -Path $PSScriptRoot/teletekst.json
}

Get-TeletekstNews -Type Domestic, Foreign `
| ForEach-Object -Begin $Begin -Process $Process -End $End -Verbose