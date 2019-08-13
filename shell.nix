{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python37"
}:
  with pkgs;
  let
    python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs;
  in
    let
      drvs = import ./default.nix { inherit pkgs pythonPath; };
      overrideDrv = drvName: drv:
        drv.overridePythonAttrs (attrs: {
          src = null;
          nativeBuildInputs = [
            python.pkgs.pip 
          ]
          ++ (if drvName == "gpu" then [ cudatoolkit ] else [])
          ++ (lib.attrByPath [ "nativeBuildInputs" ] [] attrs);
          # tests are disabled during nix-build, but we want the checkInputs in shell.nix
          doCheck = true;
          shellHook = ''
            echo 'Entering ${attrs.pname}'
            set -o allexport
            . ./.env
            set +o allexport
            set -v

            # extra pip packages
            unset SOURCE_DATE_EPOCH
            export PIP_PREFIX="$(pwd)/pip_packages"
            PIP_INSTALL_DIR="$PIP_PREFIX/lib/python${python.pythonVersion}/site-packages"
            export PYTHONPATH="$PIP_INSTALL_DIR:$PYTHONPATH"
            export PATH="$PIP_PREFIX/bin:$PATH"
            mkdir --parents "$PIP_INSTALL_DIR"

            # tensorflow tries to install incompatible version of setuptools
            pip install --editable . --no-deps

            # create temporary directory
            mkdir --parents tmp

            set +v
          '';
        });
    in
      lib.mapAttrs overrideDrv drvs
