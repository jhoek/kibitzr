function Send-KibitzrNotification
{
    param
    (
        [string]$Url,

        [ValidateNotNullOrEmpty()]
        [string]$UniqueID = $Url,

        [Parameter(Mandatory)]
        [string]$ApplicationToken,

        [Parameter(Mandatory)]
        [string]$Recipient,

        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('Lowest', 'Low', 'Normal', 'High')]
        [string]$Priority = 'Normal',

        [string]$Title,

        [string]$ImageUrl,

        [string]$TableName = 'notifications'
    )

    switch (Test-AirTableRecord -BaseName appB4Jzod47gLXUVE -TableName $TableName -FieldName Url -Value $UniqueID)
    {
        $false
        {
            $Parameters = @{ }
            $Parameters.ApplicationToken = $ApplicationToken
            $Parameters.Recipient = $Recipient
            $Parameters.Message = $Message
            $Parameters.Priority = $Priority

            if ($Url)
            {
                $Parameters.SupplementaryUrl = $Url
            }

            if ($Title)
            {
                $Parameters.Title = $Title
            }

            if ($ImageUrl)
            {
                $TempFilePath = New-TemporaryFile
                Invoke-WebRequest -Uri $ImageUrl -OutFile $TempFilePath
                $Parameters.AttachmentFileName = $TempFilePath
            }

            Send-PushoverNotification @Parameters

            if ($ImageUrl)
            {
                Remove-Item -Path $TempFilePath -ErrorAction SilentlyContinue
            }

            New-AirTableRecord -BaseName appB4Jzod47gLXUVE -TableName $TableName -Fields @{Url = $UniqueID }
        }

        $true
        {
            Write-Warning "Notification for '$UniqueID' already sent."
        }
    }
}