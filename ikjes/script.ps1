while ($true)
{
    $Index = Invoke-WebRequest -Uri https://www.nrc.nl/rubriek/ikje |
        Select-Object -ExpandProperty Content |
        ./pup 'a.nmt-item__link attr{href}'
    $Content = Invoke-WebRequest -Uri "https://www.nrc.nl$($Index[0])" |
        Select-Object -ExpandProperty Content
    $Title = $Content | ./pup 'h1[data-flowtype="headline"] text{}'
    $Body = ($Content | ./pup 'div.content p text{}') -join ' '

    Send-PushoverNotification -ApplicationToken afdyp3jviqdcc19qq8qytb4y9p9ojs -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp -Title $Title -Message $Body

    Start-Sleep -Seconds (60 * 60 * 24)
}