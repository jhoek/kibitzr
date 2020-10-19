#!/usr/bin/env pwsh

Set-Location -Path ~/github/tvguide -ErrorAction Stop

$Channels = @{
    'npo-1'    = 'NPO 1'
    'npo-2'    = 'NPO 2'
    'npo-3'    = 'NPO 3'
    'bbc-one'  = 'BBC One'
    'bbc-two'  = 'BBC Two'
    'bbc-four' = 'BBC Four'
}

$Channels.Keys.ForEach{
    $CurrentChannel = $_
    $Entries = Get-TvGuide -Channel $CurrentChannel
    $IsFirst = $true

    $Entries.ForEach{
        if (-not $IsFirst )
        {
            # Report previous entry
            $End = $_.DateTime
            New-CalendarEvent -Start $Start -End $End -Summary $Summary
        }

        # Prepare for reporting current entry
        $IsFirst = $false
        $Start = $_.DateTime
        $Summary = $_.Title
    } | Export-Calendar -Name $Channels[$CurrentChannel] -Path "$CurrentChannel.ics"
}

git add *
git commit -m "Updated tv guide from $(uname -n)"
git push