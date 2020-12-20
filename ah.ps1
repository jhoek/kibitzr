#!/usr/bin/pwsh
Push-Location -Path ~/github/ah -ErrorAction Stop

try
{
    Get-AHStore -ID 1844, 1083, 1541, 1855 `
    | ForEach-Object {
        $CurrentStore = $_
        $Description = "AH $($CurrentStore.Street) ($($CurrentStore.City))"

        $CurrentStore.OpeningHours | ForEach-Object {
            New-CalendarEvent -Start $_.From -End $_.To -Summary $Description
        } | Export-Calendar -Name $Description -Path "$($CurrentStore.ID).ics"
}

git add *
git commit -m "Updated AH opening hours from $(uname -n)"
git push
}
finally
{
    Pop-Location
}