#!/usr/bin/pwsh
. $PSScriptRoot/Get-TextSimilarity.ps1

Import-Module UncommonSense.Teletekst

function ConvertTo-Base64
{
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Value
    )

    [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Value))
}
function Send-TeletekstNotification
{
    param
    (
        [ValidateNotNullOrEmpty()][string]$CachePath = "$PSScriptRoot/teletekst.json",
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][string]$Title,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][string]$Content,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][string]$Link,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][DateTime]$DateTime
    )

    begin
    {
        $CachedItems = @()
        $AddToCache = @()

        if (Test-Path -Path $CachePath)
        {
            Write-Verbose "Using cache path $CachePath"

            $CachedItems = Get-Content -Path $PSScriptRoot/teletekst.json |
                ConvertFrom-Json -Depth 10 |
                Where-Object DateTime -GT (Get-Date).AddDays(-2)

            Write-Verbose "$($CachedItems.Length) items found in cache file."
        }
    }

    process
    {
        $CurrentItem = $_
        $CurrentItemAsText = "$($CurrentItem.Title) - $($CurrentItem.Content)"
        $Hash = (ConvertTo-Base64 -Value $CurrentItemAsText)

        if ($CachedItems | Where-Object Hash -EQ $Hash)
        {
            Write-Verbose "$($CurrentItem.Title) unchanged; skipping"
            return
        }

        $CachedItems.ForEach{
            $CurrentCachedItem = $_
            $CurrentCachedItemAsText = "$($CurrentCachedItem.Title) - $($CurrentCachedItem.Content)"
            $Similarity = Get-TextSimilarity $CurrentItemAsText $CurrentCachedItemAsText

            if ($Similarity) -gt 0.7
            {
                # Send as update

                $AddToCache = $AddToCache + [PSCustomObject]@{
                    Title    = $CurrentItem.Title
                    Content  = $CurrentItem.Content
                    Hash     = $Hash
                    DateTime = (Get-Date).ToString('s')
                }

                return
            }
        }

        Write-Verbose "New (or substantially changed) item '$($CurrentItem.Title)'"

        Send-PushoverNotification `
            -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
            -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
            -Title $CurrentItem.Title `
            -Message $CurrentItem.Content `
            -SupplementaryUrl $CurrentItem.Link

        $AddToCache = $AddToCache + [PSCustomObject]@{
            Title    = $CurrentItem.Title
            Content  = $CurrentItem.Content
            Hash     = $Hash
            DateTime = (Get-Date).ToString('s')
        }

    }

    end
    {
        $CachedItems = $CachedItems + $AddToCache
        $CachedItems | ConvertTo-Json -Depth 10 | Set-Content -Path $PSScriptRoot/teletekst.json

    }
}

Get-TeletekstNews -Type Domestic, Foreign | Send-TeletekstNotification -Verbose