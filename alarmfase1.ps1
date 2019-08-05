#!/usr/bin/pwsh
$ProgressPreference = 'SilentlyContinue'
$env:PATH = ($env:PATH, '/usr/local/bin') -join ':'

1109, 3286, 1432, 1187, 1185 `
| ForEach-Object {
    Get-P2000Entry -Postcode $_ `
    | Where-Object Priority -in 'P1', 'A1' `
    | Where-Object DateTime -gt (Get-Date).AddMinutes(-10) `
    | Select-Object -First 10 `
    | ForEach-Object {
        Send-PushoverNotification `
        -ApplicationToken aoiqq9zfsf32aodh55zoyg9rc3zhrh `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title $_.Title `
        -Message $_.Original `
        -SupplementaryUrl $_.Link
    }
}