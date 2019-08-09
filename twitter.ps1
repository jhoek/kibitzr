#!/usr/bin/pwsh
$ProgressPreference = 'SilentlyContinue'
$env:PATH = ($env:PATH, '/usr/local/bin') -join ':'

$Message = ''
$Title = ''

try
{
    $Response = Invoke-WebRequest -Uri https://twitter.com/jhoek

    $Message = switch ($true)
    {
        ($Response.StatusCode -ne 200)
        {
            "Oops. Status code $($Response.StatusCode)"
            break
        }

        $true
        {
            $Title = $Response.Content | pup 'title text{}' --plain
        }

        ($Title -ne 'joel mori (@jhoek) | Twitter')
        {
            "Page title is now '$Title'"
            break
        }
    }
}
catch
{
    $Message = $_.Message
}

if ($Message)
{
    Send-PushoverNotification `
        -ApplicationToken atn8y271emxoybxvczp63ae3zvgkcs `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title 'twitter.com/jhoek' `
        -Message $Message `
        -SupplementaryUrl 'https://twitter.com/jhoek'
}