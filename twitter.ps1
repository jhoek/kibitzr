#!/usr/bin/pwsh
$ProgressPreference = 'SilentlyContinue'
$env:PATH = ($env:PATH, '/usr/local/bin') -join ':'

$Message = ''
[ValidateSet('Lowest', 'Low', 'Normal', 'High')]$Priority = 'Normal'
$Title = ''

try
{
    $Response = Invoke-WebRequest -Uri 'https://mobile.twitter.com/jhoek'

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

        ($Title -notin 'joel mori (@jhoek) | Twitter', 'joel mori (@jhoek) on Twitter')
        {
            "Page title is now '$Title'"
            $Priority = 'High'
            break
        }

        $true
        {
            $Priority = 'Lowest'
            "Page title is still '$Title'"
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
        -Priority $Priority `
        -SupplementaryUrl 'https://twitter.com/jhoek'
}