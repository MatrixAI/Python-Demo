# Python Demo

[![pipeline status](https://gitlab.com/MatrixAI/open-source/Python-Demo/badges/master/pipeline.svg)](https://gitlab.com/MatrixAI/open-source/Python-Demo/commits/master)

## Installation

Building the package (as a library):

```sh
nix-build -E '(import ./pkgs.nix).python3Packages.callPackage ./default.nix {}'
```

Building the releases:

```sh
nix-build ./release.nix --attr library
nix-build ./release.nix --attr application
nix-build ./release.nix --attr docker
```

Install into Nix user profile:

```sh
nix-env -f ./release.nix --install --attr application
```

Install into Docker:

```sh
docker load --input "$(nix-build ./release.nix --attr docker)"
```
