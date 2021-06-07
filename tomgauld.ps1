#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

$AmericanCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'en-US'

Invoke-WebRequest -Uri 'https://www.newscientist.com/author/tom-gauld/'
| Select-Object -ExpandProperty Links
| Where-Object href -like '/article/*'
| ForEach-Object { $Url = "https://www.newscientist.com$($_.href)"; $Url }
| ForEach-Object { Invoke-WebRequest -Uri $_ }
| Select-Object -ExpandProperty Content
| ForEach-Object {
    $DateText = (($_ | pup '.published-date text{}' --plain) -join '' -replace '[\r\n]', '').Trim()
    $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy', $AmericanCulture)
    $Title = (($_ | pup 'h1 text{}' --plain) -join '' -replace '[\r\n]', '').Trim()
    $Image = ($_ | pup 'figure.article-image-inline img attr{data-src}') -replace '300$', '600'

    Send-KibitzrNotification `
        -Url $Url `
        -UniqueID $Url `
        -ApplicationToken ahyxa81gbw19qkniyobbxm5nj7cxyb `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message $Date.ToShortDateString() `
        -Title $Title `
        -ImageUrl $Image `
} 
