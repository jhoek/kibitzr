#!/usr/bin/env pwsh

Invoke-WebRequest -Uri 'https://magpi.raspberrypi.org'
| Select-Object -ExpandProperty Links
| Where-Object href -Match '^/issues/(.*)/pdf$'
| Select-Object -ExpandProperty href
| ForEach-Object { Invoke-WebRequest "https://magpi.raspberrypi.org$_/download" }
| Select-Object -ExpandProperty Links
| Where-Object class -EQ 'c-link'
| Select-Object -ExpandProperty href
| ForEach-Object { Invoke-WebRequest "https://magpi.raspberrypi.org$_" -OutFile "/shared/MagPi $($Matches[1]).pdf" }
