param(
    [parameter(Mandatory = $true)]
    [String]$tag
)

$pwd = [string](Get-Location)
$packages = Get-Content -Raw -Path "$pwd/packages.json" | ConvertFrom-Json | Select-Object -expand packages
$packagesToDelete = @()
$packagesToInstall = @()
$packagesToInstallWithOpts = @()

foreach ($package in $packages)
{
    if ($package.tags.count -eq 0 -or $package.tags -notcontains $tag)
    {
        $packagesToDelete += $package.name
    }

    if ($package.tags.count -gt 0 -and $package.tags -contains $tag)
    {
        if (-not([string]::IsNullOrEmpty($package.opts)))
        {
            $packageName = $package.name
            $packageOptions = $package.opts
            $packagesToInstallWithOpts += "$packageName $packageOptions"
        }

        if (([string]::IsNullOrEmpty($package.opts)))
        {
            $packagesToInstall += $package.name
        }
    }
}

$packagesToDelete = $packagesToDelete | Sort-Object
$packagesToInstall = $packagesToInstall | Sort-Object
$packagesToInstallWithOpts = $packagesToInstallWithOpts | Sort-Object

choco uninstall -Y $packagesToDelete
choco upgrade -Y $packagesToInstall

foreach ($package in $packagesToInstallWithOpts)
{
    choco upgrade -Y $package
}