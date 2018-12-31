while ($true)
{
    $Content = Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' | Select-Object -ExpandProperty Content
    $NoScript = ($Content | pup --plain '.nmt-layout .nmt-item:first-of-type noscript') -join ' '
    $Link = [regex]::Match($NoScript, 'src="(.*?)"').Groups[1].Value
    $Hyperlink = ($Content | pup '.nmt-layout .nmt-item:first-of-type a attr{href}')
    $Date = (($HyperLink -split '/')[2..4]) -join '.'

    Send-PushoverNotification `
        -ApplicationToken av5b3yspt9nzrphgdpq135fa64do6j `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title Sudoku `
        -Message $Date `
        -SupplementaryUrl $Link `
        -SupplementaryUrlTitle Link

    Start-Sleep -Seconds (60 * 60 * 24)
}