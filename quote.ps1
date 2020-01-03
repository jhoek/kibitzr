#!/usr/bin/env pwsh
$ProgressPreference = 'SilentlyContinue'

$Quote = (Invoke-RestMethod -Uri http://quotes.rest/qod.json?category=funny).contents.quotes.quote

Send-PushoverNotification `
    -ApplicationToken aupk8njz11vzgqct2vrhk6n6q5zrc1 `
    -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
    -Title 'Quote of the Day' `
    -Message $Quote `
    -Priority Low