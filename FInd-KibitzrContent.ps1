function Find-KibitzrContent
{
    param
    (
        [Parameter(Mandatory)]
        [string]$IndexUrl,

        $ItemSelector,

        [Parameter(Mandatory)]
        $TitleSelector,

        [Parameter(Mandatory)]
        $BodySelector
    )

    $Content = @(Invoke-WebRequest -Uri $IndexUrl | Select-Object -ExpandProperty Content)

    if ($ItemSelector)
    {
        $Content =
        $Content `
        | Select-KibitzrElement -Selector $ItemSelector `
        | ForEach-Object { $Url = [System.Uri]$IndexUrl; "$($Url.Scheme)://$($Url.Host)$($_)" } `
        | ForEach-Object { Invoke-WebRequest -Uri $_ | Select-Object -ExpandProperty Content }
}

$Content | Find-KibitzrItem -TitleSelector $TitleSelector -BodySelector $BodySelector
}

function Find-KibitzrItem
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Content,

        [Parameter(Mandatory)]
        $TitleSelector,

        [Parameter(Mandatory)]
        $BodySelector
    )

    process
    {
        $Content.ForEach{
            [pscustomobject]@{
                Title      = $_ | Select-KibitzrElement -Selector $TitleSelector
                Body       = $_ | Select-KibitzrElement -Selector $BodySelector
                PSTypeName = 'UncommonSense.Kibitzr.Item'
            }
        }
    }
}

function Select-KibitzrElement
{
    [CmdletBinding(DefaultParameterSetName = 'Selector')]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Content,

        [Parameter(Mandatory)]
        $Selector
    )

    switch ($true)
    {
        ($Selector -is [string])
        {
            $Content | pup $Selector --plain
            break
        }

        ($Selector -is [scriptblock])
        {
            Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $Content
            break
        }

        default
        {
            throw 'Cannot evaluate kibitzr element. Please, pass either a selector string or a scriptblock.'
        }
    }
}