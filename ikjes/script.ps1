$ProgressPreference = 'SilentlyContinue'

$Result = New-Object -TypeName System.Collections.ArrayList

Invoke-WebRequest -Uri https://www.nrc.nl/rubriek/ikje `
    | Select-Object -ExpandProperty Content `
    | ./pup 'a.nmt-item__link attr{href}' `
    | Select-Object -First 10 `
    | ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    Invoke-WebRequest -Uri $Url `
        | Select-Object -ExpandProperty Content `
        | ForEach-Object {
        $DateText = (($Url -split '/')[4..6]) -join '-'

        $Properties = [Ordered]@{
            Date  = [DateTime]::ParseExact($DateText, 'yyyy-MM-dd', $null)
            Title = ($_ | ./pup 'h1[data-flowtype="headline"] text{}')
            Body  = ($_ | ./pup 'div.content p text{}') -join ' '
            Url   = $Url
        }

        $Result.Add($Properties) | Out-Null
    }
}

$Result | ConvertTo-Json