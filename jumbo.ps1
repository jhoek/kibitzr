#!/usr/bin/pwsh
Push-Location -Path ~/github/jumbo -ErrorAction Stop

try
{
    Get-JumboStore -ID 'jumbo-veenendaal-huibers' `
    | ForEach-Object {
        $CurrentStore = $_
        $Description = $CurrentStore.Name

        $CurrentStore.OpeningHours | ForEach-Object {
            New-CalendarEvent -Start $_.From -End $_.To -Summary $Description
        } | Export-Calendar -Name $Description -Path "$($CurrentStore.ID).ics"
}

git add *
git commit -m "Updated Jumbo opening hours from $(uname -n)"
git push
}
finally
{
    Pop-Location
}