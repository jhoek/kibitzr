while ($true)
{
    $Index = Invoke-WebRequest -Uri https://www.volkskrant.nl/search?query=sylvia+witteman |
        Select-Object -ExpandProperty Content |
        pup 'article a attr{href}' |
        Where-Object { $_ -like '/mensen/*' } |
        ForEach-Object { "https://volkskrant.nl$($_)" }

    $Index

    Start-Sleep -Seconds (60 * 60 * 24)
}