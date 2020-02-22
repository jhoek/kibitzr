#!/usr/bin/pwsh
function Get-NormalOpeningHours
{
    param
    (
        [Parameter(Mandatory)][int]$StoreID,
        [Parameter(Mandatory)][DayOfWeek]$DayOfWeek,
        [Parameter(Mandatory)][ValidateSet('From', 'To')][string]$Which
    )

    $From, $To = switch ($StoreID)
    {
        1844 #Achtergracht, Weesp
        {
            switch ($DayOfWeek)
            {
                ([DayOfWeek]::Sunday) { [TimeSpan]'09:00', [TimeSpan]'20:00' }
                default { [timespan]'08:00', [timespan]'22:00' }
            }
        }
        1083 # Amstellandlaan, Weesp
        {
            switch ($DayOfWeek)
            {
                ([DayOfWeek]::Sunday) { [TimeSpan]'09:00', [TimeSpan]'20:00' }
                default { [timespan]'08:00', [timespan]'22:00' }
            }
        }
        1541 # Weth. van der Veldenweg, Numansdorp
        {
            switch ($DayOfWeek)
            {
                ([DayOfWeek]::Sunday) { break }
                default { [timespan]'08:00', [timespan]'21:00' }
            }
        }
        1855 # Maxis
        {
            switch ($DayOfWeek)
            {
                ([DayOfWeek]::Sunday) { [TimeSpan]'10:00', [TimeSpan]'19:00' }
                default { [timespan]'08:00', [timespan]'21:00' }
            }
        }
    }

    switch ($Which)
    {
        'From' { $From }
        'To' { $To }
    }
}


Get-AHStore -ID 1844, 1083, 1541, 1855 `
| ForEach-Object {
    $CurrentStore = $_

    $Store = "$($CurrentStore.City), $($CurrentStore.Street)"
    $OpeningHours = $CurrentStore.OpeningHours | ForEach-Object {
        $SpecialFromTime = $_.From.TimeOfDay -ne (Get-NormalOpeningHours -StoreID $CurrentStore.ID -DayOfWeek $_.From.DayOfWeek -Which From)
        $SpecialToTime = $_.To.TimeOfDay -ne (Get-NormalOpeningHours -StoreID $CurrentStore.ID -DayOfWeek $_.To.DayOfWeek -Which To)
        $SpecialTime = if ($SpecialFromTime -or $SpecialToTime) { ' (!)' }
        "{0} : {1}..{2}{3}" -f $_.From.Date.ToString('ddd dd MMM'), $_.From.ToString('HH:mm'), $_.To.ToString('HH:mm'), $SpecialTime
    }

    Send-PushoverNotification `
        -ApplicationToken a6tzomq6k7dhqmdro3x94iqitmnaih `
        -Recipient gmgm9ds8jaeqimuzbbzrzso2i26cxz `
        -Title $Store `
        -Message ($OpeningHours -join "`r") `
        -Monospace `
        -Priority Lowest
}