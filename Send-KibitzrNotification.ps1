function Send-KibitzrNotification
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Url,

        [string]$UniqueID = $Url,

        [Parameter(Mandatory)]
        [string]$ApplicationToken,

        [Parameter(Mandatory)]
        [string]$Recipient,

        [Parameter(Mandatory)]
        [string]$Message,

        [string]$Title,

        [string]$ImageUrl
    )

    switch (Test-AirTableRecord -BaseName appB4Jzod47gLXUVE -TableName notifications -FieldName Url -Value $UniqueID)
    {
        $false
        {
            $Parameters = @{ }
            $Parameters.ApplicationToken = $ApplicationToken
            $Parameters.Recipient = $Recipient
            $Parameters.Message = $Message
            $Parameters.SupplementaryUrl = $Url

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

            New-AirTableRecord -BaseName appB4Jzod47gLXUVE -TableName notifications -Fields @{Url = $UniqueID }
        }

        $true
        {
            Write-Warning "Notification for $Url already sent."
        }
    }
}