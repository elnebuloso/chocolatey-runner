# chocolatey-runner

Powershell Runner for https://chocolatey.org

## install packages from packages.json

- copy packages.dist.json to packages.json
- edit packages.json

### nodes

- all: default node, any packages defined here will be installed
- home: e.g. packages for installing at home
- work: e.g. packages for installing at work
- next to the all node any other nodes can be created

```
.\run.ps1 install [node]

## e.g. installs all packages from all and home
.\run.ps1 install home

## e.g. installs all packages from all and work
.\run.ps1 install work
```

## update

```
.\run.ps1 update
```
