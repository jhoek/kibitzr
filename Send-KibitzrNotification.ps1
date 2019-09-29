function Send-KibitzrNotification
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$ApplicationToken,

        [Parameter(Mandatory)]
        [string]$Recipient,

        [Parameter(Mandatory)]
        [string]$Message,

        [string]$Title,

        [string]$ImageUrl
    )

    switch (Test-AirTableRecord -BaseName kibitzr -TableName notifications -FieldName Url -Value $Url)
    {
        $false
        {
            $Parameters = @{ }
            $Parameters.ApplicationToken = $ApplicationToken
            $Parameters.Recipient = $Recipient
            $Parameters.Message = $Message

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

            New-AirTableRecord -BaseName kibitzr -TableName notifications -Fields @{Url = $Url }
        }

        $true
        {
            Write-Warning "Notification for $Url already sent."
        }
    }
}