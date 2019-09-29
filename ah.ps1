Get-AHStore -ID 1844, 1083, 1541, 1855 `
| ForEach-Object {
    $Store = "$($_.City), $($_.Street)"
    $OpeningHours = $_.OpeningHours | ForEach-Object { "{0}`t{1}..{2}" -f $_.From.Date.ToString('ddd d MMM'), $_.From.ToString('HH:mm'), $_.To.ToString('HH:mm') }

    Send-PushoverNotification `
        -ApplicationToken a6tzomq6k7dhqmdro3x94iqitmnaih `
        -Recipient gmgm9ds8jaeqimuzbbzrzso2i26cxz `
        -Title $Store `
        -Message ($OpeningHours -join "`r") `
        -Priority Lowest
}