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

function Compare-Text
{
    param
    (
        [Parameter(Mandatory, Position = 0)][string]$Text1,
        [Parameter(Mandatory, Position = 1)][string]$Text2
    )

    try
    {
        $FileName1 = New-TemporaryFile | Select-Object -ExpandProperty FullName
        $FileName2 = New-TemporaryFile | Select-Object -ExpandProperty FullName

        Set-Content -Path $FileName1 -Value $Text1
        Set-Content -Path $FileName2 -Value $Text2

        $Result = git diff --no-index --color-words $FileName1 $FileName2 | Select-Object -Skip 5

        $Result `
            -replace "`e\[1m(.*?)`e\[m", '<b>$1</b>' `
            -replace "`e\[31m(.*?)`e\[m", '<font color="#990000">$1</font>' `
            -replace "`e\[32m(.*?)`e\[m", '<font color="#009900">$1</font>' `
            -replace "`e\[36m(.*?)`e\[m", '<font color="#009999">$1</font>'
    }
    finally
    {
        if ($FileName1) { Remove-Item -Path $FileName1 -ErrorAction SilentlyContinue }
        if ($FileName2) { Remove-Item -Path $FileName2 -ErrorAction SilentlyContinue }
    }
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
        Write-Verbose "Run started at $(Get-Date -Format 's')"

        $CachedItems = New-Object -TypeName System.Collections.ArrayList
        $AddToCache = New-Object -TypeName System.Collections.ArrayList

        Write-Verbose "Using cache path $CachePath"

        if (Test-Path -Path $CachePath)
        {
            Write-Verbose "Loading cache file"

            $AllCacheFileContents = Get-Content -Path $CachePath | ConvertFrom-Json -Depth 10
            $CacheFileContents = $AllCacheFileContents | Where-Object DateTime -GT (Get-Date).AddDays(-2)

            if ($AllCacheFileContents.Length -ne $CacheFileContents.Length)
            {
                Write-Verbose "Discarding $($AllCacheFileContents.Length - $CacheFileContents.Length) old items."
            }

            if ($CacheFileContents.Length -eq 1)
            {
                $CacheFileContents = , $CacheFileContents
            }

            $CachedItems.AddRange($CacheFileContents)

            Write-Verbose "$($CachedItems.Count) items found in cache file."
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
        else
        {
            Write-Verbose "Hash of '$Title' is unknown"
        }

        $Similarities = $CachedItems.ForEach{
            $CurrentCachedItem = $_
            $CurrentCachedItemAsText = "$($CurrentCachedItem.Title) - $($CurrentCachedItem.Content)"
            $Similarity = Get-TextSimilarity $CurrentItemAsText $CurrentCachedItemAsText

            [PSCustomObject]@{
                CachedItem = $CurrentCachedItem
                Similarity = $Similarity
            }
        }

        $MostSimilar = $Similarities |
            Where-Object Similarity -gt 0.75 |
            ForEach-Object { Write-Verbose "Similarity with '$($_.CachedItem.Title)' was $($_.Similarity)"; $_ } |
            Sort-Object -Property Similarity |
            Select-Object -Last 1 |
            Select-Object -ExpandProperty CachedItem

        if ($MostSimilar)
        {
            Write-Verbose "'$Title' was updated; sending notification"

            Send-PushoverNotification `
                -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
                -Recipient gajrpycu8sq39dfbjn8ipjhypkhc7x `
                -Title $Title `
                -Message (Compare-Text $MostSimilar.Content $Content) `
                -SupplementaryUrl $Link `
                -Html

            $AddToCache.Add(
                [PSCustomObject]@{
                    Title    = $Title
                    Content  = $Content
                    Hash     = $Hash
                    DateTime = $DateTime
                }
            ) | Out-Null

        return
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
    Write-Verbose "Run ended at $(Get-Date -Format 's')"
}
}

Get-TeletekstNews -Type Domestic, Foreign |
    Send-TeletekstNotification -Verbose