#!/usr/bin/pwsh
$ProgressPreference = 'SilentlyContinue'
$env:PATH = ($env:PATH, '/usr/local/bin') -join ':'

1109, 3286, 1432 `
| ForEach-Object {
    Get-P2000Entry -PostCode $_ `
    | Where-Object Priority -In 'P1', 'A1' `
    | Where-Object DateTime -GT (Get-Date).AddMinutes(-3) `
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