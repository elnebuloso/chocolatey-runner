param(
    [parameter(Mandatory = $true)]
    [ValidatePattern("install|update")]
    [String]
    $command,
    [parameter(Mandatory = $false)]
    [String]
    [ValidatePattern("home|work")]
    $type
)

$pwd = [string](Get-Location)

if ($command -eq "install")
{
    $packages = Get-Content -Raw -Path "$pwd/packages.json" | ConvertFrom-Json

    foreach ($topic in $packages.PSObject.Properties)
    {
        Write-Host ''

        foreach ($node in $topic.Value.PSObject.Properties)
        {
            $list = [string]$node.Value
            $list = $list.Trim()
            $topicName = $topic.Name
            $nodeName = $node.Name

            if ($node.Name -eq "all")
            {
                if (-not([string]::IsNullOrEmpty($list)))
                {
                    Write-Host " [$topicName :: $nodeName]"
                    Write-Host " $list"
                    Write-Host ''

                    foreach ($package in $node.Value)
                    {
                        $run = "choco install -y $package"
                        iex $run
                    }
                }
            }

            if ($node.Name -eq $type)
            {
                if (-not([string]::IsNullOrEmpty($list)))
                {
                    Write-Host " [$topicName :: $nodeName]"
                    Write-Host " $list"
                    Write-Host ''

                    foreach ($package in $node.Value)
                    {
                        $run = "choco install -y $package"
                        iex $run
                    }
                }
            }
        }
    }

    Write-Host ''
}

if ($command -eq "update")
{
    $run = 'choco upgrade all --except=filebot -y'
    iex $run
}