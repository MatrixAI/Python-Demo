# Python Demo

```sh
# install as application
nix-env --file ./default.nix --arg application true --install
# install as package
nix-env --file ./default.nix --install
# install into docker
docker load --input "$(nix-build ./release.nix --attr docker)"
# build the package
nix-build
# enter the development environment
nix-shell
```
