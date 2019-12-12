param(
    [parameter(Mandatory = $true)]
    [String]$tag
)

$pwd = [string](Get-Location)

if (!(Test-Path "$pwd/packages.json"))
{
    Copy-Item "$pwd/packages.dist.json" -Destination "$pwd/packages.json"
}

$packages = Get-Content -Raw -Path "$pwd/packages.json" | ConvertFrom-Json | Select-Object -expand packages

foreach ($package in $packages)
{
    if ($package.tags.count -eq 0 -or $package.tags -notcontains $tag)
    {
        choco uninstall -y $package.name
    }

    if ($package.tags.count -gt 0 -and $package.tags -contains $tag)
    {
        choco upgrade -y $package.name $package.opts
    }
}
