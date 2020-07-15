$Content = Invoke-WebRequest -Uri 'https://www.asnbank.nl/beleggen/koersen.html' | Select-Object -ExpandProperty Content
$Headings = $Content | pup '.fundrates thead tr text{}' --plain | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$Rates = $Content | pup '.fundrates tr:nth-of-type(4) text{}' --plain | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$FundName = $RawRates[0]
$Message = (1..3 | ForEach-Object { "$($Headings[$_]): &euro;$($Rates[$_])" }) -join "`n"

Send-PushoverNotification `
    -ApplicationToken a635f2bxdynw7z839eb49o7dn1312c `
    -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
    -Title $FundName `
    -Message $Message `
    -Html