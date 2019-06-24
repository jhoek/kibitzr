. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' `
| Select-Object -ExpandProperty Content `
| pup --plain '.nmt-item__link json{}' `
| ConvertFrom-Json -Depth 10 `
| ForEach-Object { $_.GetEnumerator() } `
| ForEach-Object {
    # $Link = [regex]::Match($NoScript, 'src="(.*?)"').Groups[1].Value
    ($_.children[0].children[0].children[1].text) | Select-String -Pattern 'src="(.*?)"' | Select-Object -ExpandProperty Matches | Select-Object -Skip 1 -First 1 -ExpandProperty Value

    $Url = $_.ref
    $DateElements = $Url -split '/'
    $Date = Get-Date -Year $DateElements[2] -Month $DateElements[3] -Day $DateElements[4]
    #$Body = '<img src="{0}"></img>' -f 

    Save-EntryToAirTable -TableName sudoku -Url $Url -Date $Date -Title Sudoku -Body $Body
}



# $Hyperlink = ($Content | pup '.nmt-layout .nmt-item:first-of-type a attr{href}')

# Send-PushoverNotification `
#     -Message $Date `
#     -SupplementaryUrl $Link `
#     -SupplementaryUrlTitle Link
