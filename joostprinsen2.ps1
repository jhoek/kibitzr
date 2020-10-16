Invoke-WebRequest https://www.haarlemsdagblad.nl/cnt/DMF20201013_80076619/meneer-rouw-stapt-vermomd-en-op-de-meest-onverwachte-momenten-bij-me-binnen-column-joost-prinsen
| Select-Object -ExpandProperty Content
| pup 'script json{}'
| ConvertFrom-Json
| Where-Object text -like 'window`["__PRE*'
| Select-Object -First 1 -ExpandProperty Text
| ForEach-Object { $_ -replace '^window\["__PRELOADED_STATE_GRAPH__[^"]*"\] = ', '' }
| jq '[.[]][0] | { title: .title, intro: ([.intro.json[].p]|join(\" \")), body: ([.body.json[].p]|join(\" \"))}'
| ConvertFrom-Json
| Format-List