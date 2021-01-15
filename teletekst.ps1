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

        if (Test-Path -Path $CachePath)
        {
            Write-Verbose "Using cache path $CachePath"

            $CachedItems.AddRange(
                @(,
                    (Get-Content -Path $PSScriptRoot/teletekst.json |
                            ConvertFrom-Json -Depth 10 |
                            Where-Object DateTime -GT (Get-Date).AddDays(-2)
                    )
                )
            )

            Write-Verbose "$($CachedItems.Length) items found in cache file."
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

        $CachedItems.ForEach{
            $CurrentCachedItem = $_
            $CurrentCachedItemAsText = "$($CurrentCachedItem.Title) - $($CurrentCachedItem.Content)"
            $Similarity = Get-TextSimilarity $CurrentItemAsText $CurrentCachedItemAsText

            if ($Similarity -gt 0.7)
            {
                Write-Verbose "'$Title' was updated; sending notification"

                $AddToCache.Add(
                    [PSCustomObject]@{
                        Title    = $Title
                        Content  = $Content
                        Hash     = $Hash
                        DateTime = $DateTime
                    }
                )

                return # continue? exit? ...?
            }
        }

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
        )
    }

    end
    {
        $CachedItems.AddRange($AddToCache)
        $CachedItems | ConvertTo-Json -Depth 10 | Set-Content -Path $PSScriptRoot/teletekst.json
    }
}

#Get-TeletekstNews -Type Domestic, Foreign |

Send-TeletekstNotification `
    -Title 'My Title Goes Here' `
    -Content 'My Content Goes Here. My Content Goes Here. My Content Goes Here.' `
    -Link 'https://example.com' `
    -DateTime (Get-Date) `
    -Verbose