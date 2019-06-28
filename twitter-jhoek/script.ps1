$Title = Invoke-WebRequest -Uri 'https://twitter.com/jhoek' |
    Select-Object -ExpandProperty Content |
    pup 'title text{}'

if ($Title -notlike '*joel mori*')
{
    Send-PushoverNotification `
        -ApplicationToken atn8y271emxoybxvczp63ae3zvgkcs `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title "twitter.com/jhoek" `
        -Message "might be available!"
}