param
(
    [ValidateSet('jan', 'feb', 'mrt', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec')]
    [string]$Month = (Get-Date).ToString('MMM', [cultureinfo]::new('nl-NL')).TrimEnd('.'),

    [ValidatePattern('\d{4}')]
    [string]$Year = (Get-Date).ToString("yyyy"),

    [ValidateRange(1, [int]::MaxValue)]
    [int]$FromPage = 1,

    [ValidateRange(1, [int]::MaxValue)]
    [int]$ToPage = 40,

    [ValidateNotNullOrEmpty()]
    [string]$WorkingFolder = (New-TemporaryFile),

    [ValidateNotNullOrEmpty()]
    [string]$Destination = "~/Desktop"
)

if ($ToPage -lt $FromPage)
{
    Write-Warning '$FromPage greater than $ToPage; swapping'
    $FromPage, $ToPage = $ToPage, $FromPage
}

Remove-Item -Path $WorkingFolder
New-Item -Path $WorkingFolder -ItemType Container | Out-Null

open $WorkingFolder

$FromPage..$ToPage
| ForEach-Object {
    $Url = 'https://onzetaal.nl/flipbook/{0}-{1}/files/mobile/{2}.jpg' -f $Month, $Year, $_
    Write-Host $Url
    $OutFile = Join-Path -Path $WorkingFolder -ChildPath ('{0:d2}.jpg' -f $_)
    $Response = Invoke-WebRequest -Uri $Url -OutFile $OutFile -SkipHttpErrorCheck -PassThru
    Write-Host $Response.Headers['Content-Type']

    if ( $Response.Headers['Content-Type'].StartsWith('text/html'))
    {
        Remove-Item $OutFile
    }
}

$WorkingFileName = "$Month-$Year.pdf"
$WorkingFilePath = Join-Path -Path $WorkingFolder -ChildPath $WorkingFileName
$DestinationFilePath = Join-Path -Path $Destination -ChildPath $WorkingFileName

convert "$WorkingFolder/*.jpg" "$WorkingFilePath"
Move-Item -Path $WorkingFilePath -Destination $DestinationFilePath

Remove-Item -Path $WorkingFolder -Recurse -Force