Get-ChildItem -Path ./.github/workflows
| Where-Object Extension -EQ '.yml'
| Split-Path -LeafBase
| ForEach-Object { "[![$_](https://github.com/jhoek/kibitzr/actions/workflows/$_.yml/badge.svg)](https://github.com/jhoek/kibitzr/actions/workflows/$_.yml)" }
| Set-Content ./README.md