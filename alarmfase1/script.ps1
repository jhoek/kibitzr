. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

'amsterdam-amstelland', 'gooi-en-vechtstreek', 'zuid-holland-zuid' `
| ForEach-Object {
    Get-P2000Entry -Region $_ `
    | ForEach-Object {
        Save-EntryToAirTable `
            -TableName alarmfase1 `
            -Url $_.Link `
            -Title $_.Title `
            -Date $_.DateTime `
            -Body $_.Original
    }
}