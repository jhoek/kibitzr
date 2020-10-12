#!/usr/bin/env pwsh

Get-TriodosFundPrice
| Where-Object Fund -eq 'Triodos Global Equities Impact Fund'
| ForEach-Object {
    Send-PushoverNotification `
        -ApplicationToken a7dcpcdb8ekc4x5xmi7fo7zu4kgipc `
        -Recipient gr9bpnx7bsdkgzvcdo3tq554f297s5 `
        -Title $_.Fund `
        -Message "EUR $($_.Price) on $(Get-Date -Date $_.Date -Format 'd')"
}