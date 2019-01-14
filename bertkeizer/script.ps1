$PreviousUri = ''

while ($true)
{
    $Uri = 'https://trouw.nl{0}' -f (Invoke-WebRequest -Uri https://trouw.nl/bert-keizer~d5840135188caea36a9581181 |
            Select-Object -ExpandProperty Content |
            pup 'article > a:first-of-type attr{href}' |
            Select-Object -First 1)

    If ($Uri -ne $PreviousUri)
    {
        $Content = Invoke-WebRequest -Uri $Uri | Select-Object -ExpandProperty Content
        $Title = $Content | pup 'h1 text{}'
        $Body = $Content | pup --plain 'p.article__paragraph' | Select-Object -First 1

        Send-PushoverNotification `
            -ApplicationToken aiehmj2gnp9h85kgm4zxk5o79f3g5q `
            -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
            -Title "Bert Keizer: $Title" `
            -Message $Body `
            -Html `
            -SupplementaryUrl $Uri
    }

    $PreviousUri = $Uri
    Start-Sleep -Seconds (60 * 60 * 24)
}