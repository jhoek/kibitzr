function Test-NotificationAlreadySent
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Url
    )

    Test-AirTableRecord -TableName notifications -FieldName Url -Value $Url
}