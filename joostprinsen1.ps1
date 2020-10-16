2019..2020 | ForEach-Object {
    1..12 | ForEach-Object {
        $Url ='https://www.haarlemsdagblad.nl/zoeken?keyword=joost+prinsen&daterange=range&datestart=01/01/2019&dateend=31/01/2019'
    }
}

$Url ='https://www.haarlemsdagblad.nl/zoeken?keyword=joost+prinsen&daterange=range&datestart=01/01/2019&dateend=31/01/2019'

Invoke-WebRequest -Uri $Url |
Select-Object -ExpandProperty Links |
Select-Object -ExpandProperty href |
Where-Object { $_ -like '/cnt/dmf*'} |
ForEach-Object { "https://haarlemsdagblad.nl$($_)"}
