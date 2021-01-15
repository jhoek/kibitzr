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
        $CachedItems = New-Object -TypeName System.Collections.ArrayList
        $AddToCache = New-Object -TypeName System.Collections.ArrayList

        Write-Verbose "Using cache path $CachePath"

        if (Test-Path -Path $CachePath)
        {
            Write-Verbose "Loading cache file"

            $CacheFileContents = Get-Content -Path $CachePath |
                ConvertFrom-Json -Depth 10 |
                Where-Object DateTime -GT (Get-Date).AddDays(-2)
            $CacheFileContents = @(, $CacheFileContents)
            $CachedItems.AddRange($CacheFileContents)

            Write-Verbose "$($CachedItems.Length) items found in cache file."
        }
        else
        {
            Write-Verbose "Cache file not found"
        }
    }

    process
    {
        $CurrentItemAsText = "$Title - $Content"
        $Hash = (ConvertTo-Base64 -Value $CurrentItemAsText)

        if ($CachedItems | Where-Object Hash -EQ $Hash)
        {
            Write-Verbose "'$Title' unchanged; skipping"
            return
        }

        $SimilarItemWasFound = $false

        $CachedItems.ForEach{
            $CurrentCachedItem = $_
            $CurrentCachedItemAsText = "$($CurrentCachedItem.Title) - $($CurrentCachedItem.Content)"
            $Similarity = Get-TextSimilarity $CurrentItemAsText $CurrentCachedItemAsText
            Write-Verbose "Similarity with '$($CurrentCachedItem.Title)' was $Similarity"

            if ($Similarity -gt 0.7)
            {
                Write-Verbose "'$Title' was updated; sending notification"

                Send-PushoverNotification `
                    -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
                    -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
                    -Title $Title `
                    -Message $Content `
                    -SupplementaryUrl $Link

                $AddToCache.Add(
                    [PSCustomObject]@{
                        Title    = $Title
                        Content  = $Content
                        Hash     = $Hash
                        DateTime = $DateTime
                    }
                ) | Out-Null

            $SimilarItemWasFound = $true
            return
        }
    }

    if ($SimilarItemWasFound) { return }

    Write-Verbose "'$Title' new or substantially different; sending notification"

    Send-PushoverNotification `
        -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
        -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
        -Title $Title `
        -Message $Content `
        -SupplementaryUrl $Link

    $AddToCache.Add(
        [PSCustomObject]@{
            Title    = $Title
            Content  = $Content
            Hash     = $Hash
            DateTime = $DateTime
        }
    ) | Out-Null
}

end
{
    if ($AddToCache)
    {
        Write-Verbose "Adding $($AddToCache.Count) new items to the cache"
        $CachedItems.AddRange($AddToCache)
    }

    Write-Verbose "Writing $($CachedItems.Count) items to cache path $CachePath"
    $CachedItems | ConvertTo-Json -Depth 10 | Set-Content -Path $CachePath
}
}

#Get-TeletekstNews -Type Domestic, Foreign |

# Remove-Item -Path $PSScriptRoot/teletekst.json -ErrorAction SilentlyContinue

Send-TeletekstNotification `
    -Title 'My Title Goes Here' `
    -Content 'Your Content Goes Here. My Text Goes Here. My Content Goes Here.' `
    -Link 'https://example.com' `
    -DateTime (Get-Date) `
    -Verbose