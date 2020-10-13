#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

function Format-Value($Date, $Value, $PreviousValue)
{
    switch ($true)
    {
        ($PreviousValue -eq 0 -or $Value -eq $PreviousValue) { return "$($Date): &euro;$Value" }
        ($Value -gt $PreviousValue) { return "$($Date): <font color='#090'>&euro;$Value &#x25B2; &euro; $($Value - $PreviousValue)</font>"; break }
        ($Value -lt $PreviousValue) { return "$($Date): <font color='#900'>&euro;$Value &#x25BC; &euro; $($Value - $PreviousValue)</font>" }
    }
}

$DataFileName = "$PSScriptRoot/triodos.xml"
$Data = if (Test-Path -Path $DataFileName)
{
    [hashtable](Import-Clixml -Path $DataFileName)
}
else
{
    @{ }
}

Get-TriodosFundPrice
| Where-Object Fund -eq 'Triodos Global Equities Impact Fund'
| ForEach-Object {
    $DateText = Get-Date -Date $_.Date -Format "yyyy'-'MM'-'dd"
    $Data[$DateText] = $_.Price
    $Title = $_.Fund
}

$NewData = [Ordered]@{ }
$Data.Keys
| Sort-Object -Descending
| Select-Object -First 3
| ForEach-Object { $NewData[$_] = $Data[$_] }

$NewData | Export-Clixml -Path $DataFileName

$PreviousValue = 0

$Message = $NewData.GetEnumerator()
| Sort-Object Name
| ForEach-Object {
    $_ | Add-Member -NotePropertyName Text -NotePropertyValue (Format-Value $_.Key $_.Value $PreviousValue) -PassThru
    $PreviousValue = $_.Value
}
| Sort-Object Name -Descending
| Select-Object -ExpandProperty Text

Send-PushoverNotification `
    -ApplicationToken a7dcpcdb8ekc4x5xmi7fo7zu4kgipc `
    -Recipient gr9bpnx7bsdkgzvcdo3tq554f297s5 `
    -Title $Title `
    -Message ($Message -join "`n") `
    -Html