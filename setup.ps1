param(
    [parameter(Mandatory = $true)]
    [String]$tag
)

$userHome = Resolve-Path "~"

$paths = @(
    "$userHome/Google Drive/choco/packages.json",
    "$userHome/Dropbox/choco/packages.json",
    "$userHome/choco/packages.json"
)

foreach ($packageJson in $paths) {
    Write-Host $packageJson

    if([System.IO.File]::Exists($packageJson)) {
        break
    }
}

$pwd = [string](Get-Location)
$packages = Get-Content -Raw -Path $packageJson | ConvertFrom-Json | Select-Object -expand packages
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

$command = "choco uninstall --yes $packagesToDelete"
Invoke-Expression $command

$command = "choco upgrade --yes $packagesToInstall"
Invoke-Expression $command

foreach ($package in $packagesToInstallWithOpts)
{
    $command = "choco install --yes $package"
    Invoke-Expression $command
}