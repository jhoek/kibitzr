#!/usr/bin/env pwsh

function Test-PreviouslyUnseen
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Item,

        [switch]$SkipAdd,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $History = switch (Test-Path -Path $Path)
    {
        ($true) { Get-Content -Path $Path }
        ($false) { @() }
    }

    $Unseen = -not ($History -contains $Item)

    if ($Unseen -and -not $SkipAdd)
    {
        Add-Content -Path $Path -Value $Item
    }

    $Unseen
}