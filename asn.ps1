#!/usr/bin/pwsh
function Format-Value($Date, $Value, $PreviousValue)
{
    switch ($true)
    {
        ($PreviousValue -eq 0 -or $Value -eq $PreviousValue) { return "$($Date): &euro;$Value" }
        ($Value -gt $PreviousValue) { return "$($Date): <font color='#090'>&euro;$Value &#x25B2; &euro; $($Value - $PreviousValue)</font>"; break }
        ($Value -lt $PreviousValue) { return "$($Date): <font color='#900'>&euro;$Value &#x25BC; &euro; $($Value - $PreviousValue)</font>" }
    }
}

$Content = Invoke-WebRequest -Uri 'https://www.asnbank.nl/beleggen/koersen.html' | Select-Object -ExpandProperty Content
$Headings = $Content | pup '.fundrates thead tr text{}' --plain | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$Row = $Content | pup '.fundrates tr:nth-of-type(4) text{}' --plain | ForEach-Object { $_.Trim() } | Where-Object { $_ }

$Dates = $Headings[1..3]
$Rates = $Row[1..3] | ForEach-Object { [decimal]::Parse($_, [cultureinfo]::GetCultureInfo('nl-NL')) }
$FundName = $Row[0]

$Message = 0..1 |
    ForEach-Object `
        -Process { Format-Value $Dates[$_] $Rates[$_] $Rates[$_ + 1] }`
        -End { Format-Value $Dates[2] $Rates[2] 0 }

Send-PushoverNotification `
    -ApplicationToken a635f2bxdynw7z839eb49o7dn1312c `
    -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
    -Title $FundName `
    -Message ($Message -join "`n") `
    -Html