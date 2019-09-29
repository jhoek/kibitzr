function Test-NotificationAlreadySent
{
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory)]
        [string]$Url
    )

    if (-not (Test-AirTableRecord -TableName kibitzr -FieldName Url -Value $Url))
    {
        New-AirTableRecord `
            -TableName notifications `
            -Fields @{ Url = $Url }

        return false
    }
    else
    {
        Write-Warning "'$Url' already sent; skipping."
        return true
    }
}