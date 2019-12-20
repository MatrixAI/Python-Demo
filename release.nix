{ pkgs ? import ./pkgs.nix }:

with pkgs;
let
  python = python37;
in
  rec {
    library = python.pkgs.callPackage ./default.nix {};
    application = python.pkgs.toPythonApplication library;
    docker = dockerTools.buildImage {
      name = application.name;
      contents = application;
      runAsRoot = ''
        #!${runtimeShell}
        mkdir -p /tmp
        chmod 1777 /tmp
        ln -f -s ${bash}/bin/bash /bin/sh
      '';
      config = {
        Cmd = [ "/bin/python-demo-external" ];
      };
    };
  }
