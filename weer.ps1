$Weather = Invoke-RestMethod -Uri 'api.openweathermap.org/data/2.5/onecall?lat=52.30&lon=5.04&appid=819c1bbf493f03d8eaa9a50cf225d23d&units=metric&exclude=current,minutely,alerts'

$Weather.hourly.ForEach{
    $Epoch = [DateTime]::new(1970, 1, 1, 0, 0, 0, 0, [System.DateTimeKind]::Utc)
    $Epoch.AddSeconds($_.dt).ToLocalTime()

    # $_.temp
    switch ($_.weather.id)
    {
        801 { '🌤️' }
        802 { '⛅' }
        803 { '🌥️' }
        804 { '☁️' }
    }


    # $_.pop
}