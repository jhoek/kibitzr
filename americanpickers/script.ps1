$PreviousLinks = @()

while ($true)
{
    $Links = Invoke-WebRequest -Uri 'https://showrss.info/browse/224' |
        Select-Object -ExpandProperty Content |
        pup 'ul.user-timeline a attr{href}' |
        Select-Object -First 10

    Compare-Object `
        -ReferenceObject $PreviousLinks `
        -DifferenceObject $Links |
        Select-Object -ExpandProperty InputObject

    $PreviousLinks = $Links

    Start-Sleep -Seconds (5)
}

#   notify:
#     - bash: CONTENT=$(cat -); curl -s --form-string "token=a17ejjb1vto534trjiwtymadjd6prz" --form-string "user=u65ckN1X5uHueh7abnWukQ2owNdhAp" --form-string "message=$CONTENT" https://api.pushover.net/1/messages.json