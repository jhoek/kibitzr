<#
.EXAMPLE
Get-TextSimilarity 'apple orange cherry apple pear pineapple' 'apple banana cherry apple pear melon' -Verbose
#>
function Get-TextSimilarity
{
    param
    (
        [Parameter(Mandatory, Position = 0)][string]$Text1,
        [Parameter(Mandatory, Position = 1)][string]$Text2
    )

    $Words1 = $Text1 -split '[\s.,;]'
    Write-Debug "Words in Text1: $($Words1 -join ', ')"

    $Words2 = $Text2 -split '[\s.,;]'
    Write-Debug "Words in Text2: $($Words2 -join ', ')"

    $Union = Compare-Object $Words1 $Words2 -IncludeEqual -PassThru
    Write-Debug "Union: $($Union -join ', ')"

    $Intersection = Compare-Object $Words1 $Words2 -IncludeEqual -ExcludeDifferent -PassThru
    Write-Debug "Intersection: $($Intersection -join ', ')"

    $Intersection.Length / $Union.Length
}