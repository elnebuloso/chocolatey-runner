<img src="https://raw.githubusercontent.com/elnebuloso/chocolatey-runner/master/logo.png" width="100%"/>

# chocolatey-runner

Powershell Runner for https://chocolatey.org

## install packages from packages.json

- edit packages.json, add packages

```
{
    "name": "docker-desktop",
    "opts": "--version=2.1.0.5 --ignore-checksums",
    "tags": [
        "home",
        "work"
    ]
},
```

## run

- installs all packages for a given tag
- uninstalls all packages that are not tagged for the given tag

```
.\setup.ps1 [tag]
```

# useful commands

```
choco list --local-only
```