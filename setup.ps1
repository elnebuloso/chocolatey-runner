param(
    [parameter(Mandatory = $true)]
    [String]$tag,
    [parameter(Mandatory = $false)]
    [String]$dry
)

$userHome = Resolve-Path "~"

$paths = @(
"$userHome/Google Drive/choco/packages.json",
"$userHome/Dropbox/choco/packages.json",
"$userHome/choco/packages.json",
"$PSScriptRoot/packages.json"
)

foreach ($packageJson in $paths)
{
    Write-Host $packageJson

    if ( [System.IO.File]::Exists($packageJson))
    {
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
    if ($package.tags -notmatch $tag)
    {
        $packagesToDelete += $package.name
    }

    if ($package.tags -match $tag)
    {
        if (-not([string]::IsNullOrEmpty($package.tags.$tag)))
        {
            $packageName = $package.name
            $packageOptions = $package.tags.$tag
            $packagesToInstallWithOpts += "$packageName $packageOptions"
        }

        if (([string]::IsNullOrEmpty($package.tags.$tag)))
        {
            $packagesToInstall += $package.name
        }
    }
}

$packagesToDelete = $packagesToDelete | Sort-Object
$packagesToInstall = $packagesToInstall | Sort-Object
$packagesToInstallWithOpts = $packagesToInstallWithOpts | Sort-Object

if (-not([string]::IsNullOrEmpty($packagesToDelete)))
{
    $command = "choco uninstall --yes $packagesToDelete"
    Write-Host $command

    if (([string]::IsNullOrEmpty($dry)))
    {
        Invoke-Expression $command
    }
}

if (-not([string]::IsNullOrEmpty($packagesToInstall)))
{
    $command = "choco upgrade --yes $packagesToInstall"
    Write-Host $command

    if (([string]::IsNullOrEmpty($dry)))
    {
        Invoke-Expression $command
    }
}

if (-not([string]::IsNullOrEmpty($packagesToInstallWithOpts)))
{
    foreach ($package in $packagesToInstallWithOpts)
    {
        $command = "choco install --yes $package"
        Write-Host $command

        if (([string]::IsNullOrEmpty($dry)))
        {
            Invoke-Expression $command
        }
    }
}
