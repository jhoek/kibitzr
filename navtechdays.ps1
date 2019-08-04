#!/usr/bin/pwsh
$ProgressPreference = 'SilentlyContinue'

'https://navtechdays.com/sessions', # FIXME
'https://navtechdays.com/schedule/thu-21',
'https://navtechdays.com/schedule/fri-22' | ForEach-Object {
    Invoke-WebRequest -Uri $_ `
    | Select-Object -ExpandProperty Content `
    | pup --plain '.rowWrapper json{}' `
    | ConvertFrom-Json -AsHashTable `
    | ForEach-Object { $_.GetEnumerator() } `
    | ForEach-Object {
        $Row = $_['children'][0]
        $Columns = $Row['children'][0]
        $Time = $Columns['children'][0]['children'][0].text
        $Accordion = $Columns['children'][1]
        $EventItem = $Accordion['children'][0]
        $Title = $EventItem['children'][0]['children'][0].text
        $Time
    }






}


#     | pup 'a.nmt-item__link attr{href}' `
#     | Select-Object -First 10 `
#     | ForEach-Object {
#     $Url = "https://www.nrc.nl$($_)"
#     $DateText = (($Url -split '/')[4..6]) -join '-'
#     $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
#     $Title = ($Content | pup 'h1[data-flowtype="headline"] text{}')
#     $Body = ((($Content | pup 'div.content p text{}') -join ' ') -replace $SmartSingleQuotes, '''') -replace $SmartDoubleQuotes, '"'
#     $Date = [DateTime]::ParseExact($DateText, 'yyyy-MM-dd', $null)
#     $Payload = (@{fields = @{ Url = $Url; Title = $Title; Body = $Body; Date = $Date }} | ConvertTo-Json -Depth 5)

#     Write-Verbose $Payload

#     Invoke-RestMethod `
#         -Method POST `
#         -Uri 'https://api.airtable.com/v0/appB4Jzod47gLXUVE/ikjes' `
#         -ContentType 'application/json' `
#         -Headers @{'Authorization' = "Bearer $($env:AirTableApiKey)"} `
#         -Body $Payload
# }







# dateTime = "{year:0>4}{month:0>2}{day:0>2}T{hour:0>2}{minute:0>2}00Z"


# def addEvents(calendar, url, day, month, year):

#     for row in rows:
#         timeslot = row.div.div.h2.small.string
#         # print(timeslot)

#         summary = next(row.div.div.dl.dd.a.h3.stripped_strings)
#         # print(summary)

#         uid = row.div.div.dl.dd.a['href']
#         # print(uid)

#         speaker_info = row.select('div.speakerTxt h4')
#         speakers = ", ".join(
#             [speaker.get_text() for speaker in speaker_info if not speaker.has_attr("class")])
#         # print(speakers)

#         location = ""
#         tags = row.select("span.tag")
#         for tag in tags:
#             if tag.string.lower().find("room") != -1:
#                 location = tag.string
#         # print(location)

#         description = ""

#         if speakers != "":
#             description = speakers + '\n\n'

#         paragraphs = row.select("p")

#         for paragraph in paragraphs:
#             for string in paragraph.stripped_strings:
#                 description = description + string + '\n\n'
#         # print(description)

#         fromhours = int(timeslot[0:2]) - 1
#         fromminutes = int(timeslot[3:5])
#         tohours = int(timeslot[8:10]) - 1
#         tominutes = int(timeslot[11:13])

#         event = icalendar.Event()
#         event['uid'] = uid
#         event['dtstart'] = dateTime.format(
#             year=year, month=month, day=day, hour=fromhours, minute=fromminutes)
#         event['dtend'] = dateTime.format(
#             year=year, month=month, day=day, hour=tohours, minute=tominutes)
#         event['summary'] = summary
#         event['location'] = location
#         event['description'] = description
#         calendar.add_component(event)

