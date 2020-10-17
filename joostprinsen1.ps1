$DateFormat = 'dd/MM/yyyy'
$FromDate = Get-Date -Year 2019 -Month 1 -Day 1
$Today = Get-Date

while ($FromDate -lt $Today)
{
    $ToDate = $FromDate.AddMonths(1).AddDays(-1)
    $Url = 'https://www.haarlemsdagblad.nl/zoeken?keyword=joost+prinsen&daterange=range&datestart={0}&dateend={1}' -f $FromDate.ToString($DateFormat), $ToDate.ToString($DateFormat)

    Invoke-WebRequest -Uri $Url |
        Select-Object -ExpandProperty Links |
        Select-Object -ExpandProperty href |
        Where-Object { $_ -like '/cnt/dmf*' } |
        ForEach-Object { "https://haarlemsdagblad.nl$($_)" }

    $FromDate = $FromDate.AddMonths(1)
}