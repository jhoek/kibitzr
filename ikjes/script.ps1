$ProgressPreference = 'SilentlyContinue'

$Index = Invoke-WebRequest -Uri https://www.nrc.nl/rubriek/ikje |
    Select-Object -ExpandProperty Content |
    ./pup 'a.nmt-item__link attr{href}'
$Content = Invoke-WebRequest -Uri "https://www.nrc.nl$($Index[0])" |
    Select-Object -ExpandProperty Content
$Title = $Content | ./pup 'h1[data-flowtype="headline"] text{}'
$Body = ($Content | ./pup 'div.content p text{}') -join ' '

$Title
$Body