while ($true)
{
    $NoScript =
    (Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' |
            Select-Object -ExpandProperty Content |
            pup --plain '.nmt-layout .nmt-item:first-of-type noscript') -join ' '

    $Link = [regex]::Match($NoScript, 'src="(.*?)"').Groups[1].Value

    Send-PushoverNotification `
        -ApplicationToken av5b3yspt9nzrphgdpq135fa64do6j `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title Sudoku `
        -Message  `
        -SupplementaryUrl $Link

    Start-Sleep -Seconds (60 * 60 * 24)
}