$Url = 'https://graphql.1platform.be/graphql/?operationName=webv1_getSearchArticlesConnection&variables={"brand":"haarlemsdagblad.nl","count":10,"search":"joost prinsen","publishedAfter":"2020-10-07T22:00:00.000Z"}&extensions={"persistedQuery":{"version":1,"sha256Hash":"59b18fd96996fc73057a18da676e5ff36d069eda8a93578fb6094116c794d741"}}'
$url = 'https://graphql.1platform.be/graphql/?operationName=webv1_getSearchArticlesConnection&variables=%7B%22brand%22%3A%22haarlemsdagblad.nl%22%2C%22count%22%3A10%2C%22search%22%3A%22joost%20prinsen%22%2C%22publishedAfter%22%3A%222020-09-14T22%3A00%3A00.000Z%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%2259b18fd96996fc73057a18da676e5ff36d069eda8a93578fb6094116c794d741%22%7D%7D'
$url = 'https://graphql.1platform.be/graphql/?operationName=webv1_getSearchArticlesConnection&variables=%7B%22brand%22%3A%22haarlemsdagblad.nl%22%2C%22count%22%3A10%2C%22search%22%3A%22joost%20prinsen%22%2C%22publishedAfter%22%3A%222020-09-14T22%3A00%3A00.000Z%22%7D&extensions='
$Url = 'https://graphql.1platform.be/graphql/?operationName=webv1_getSearchArticlesConnection&variables={"brand":"haarlemsdagblad.nl","count":10,"search":"joost prinsen","after":"cGFnZT0xJmJ5cGFzc19wYXl3YWxsPTEmcT1qb29zdCtwcmluc2VuJnBhZ2Vfc2l6ZT0xMCZvcmRlcmluZz0tcHVibGlzaGVkX2F0JnNlYXJjaF9hZnRlciU1QiU1RD0xNTk4NDE3ODIwMDAw"}'
(Invoke-RestMethod $Url).data.search.articlesConnection.edges.node |
    Where-Object brand -eq 'haarlemsdagblad.nl'



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