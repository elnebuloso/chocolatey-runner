# chocolatey-runner

Powershell Runner for https://chocolatey.org

## install packages from packages.json

- copy packages.dist.json to packages.json
- edit packages.json

## run

- installs all packages with given tag
- uninstalls all packages that are not tagged with the given tag

```
.\setup.ps1 [tag]
```

# useful commands

```
choco list --local-only
```