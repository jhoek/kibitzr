. ./Find-KibitzrContent.ps1

Find-KibitzrContent `
    -IndexUrl https://www.volkskrant.nl/auteur/georgina-verbaan `
    -ItemSelector 'article a attr{href}' `
    -TitleSelector 'h1 text{}' `
    -BodySelector 'section.artstyle__main--container p text{}'

Find-KibitzrContent `
    -IndexUrl https://www.trouw.nl/auteur/bert-keizer `
    -ItemSelector 'article > a:first-of-type attr{href}' `
    -TitleSelector 'h1 text{}' `
    -BodySelector 'p.artstyle__text text{}' `
    -MaxItemCount 10
