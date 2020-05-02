<img src="https://raw.githubusercontent.com/elnebuloso/chocolatey-runner/master/logo.png" width="100%"/>

# chocolatey-runner

Powershell Runner for https://chocolatey.org

## install packages from packages.json

- Copy packages.dist.json to packages.json
- Place packages.json in one of these directories
  - %userprofile%\Google Drive\choco\packages.json
  - %userprofile%\Dropbox\choco\packages.json
  - %userprofile%\choco\packages.json
- The Runner will look for the existence in these directories. The first existing file will be used.

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