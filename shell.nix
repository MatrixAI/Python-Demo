{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python36"
}:
  with pkgs;
  let
    python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs;
    drv = import ./default.nix { inherit pkgs pythonPath; };
  in
    drv.overridePythonAttrs (attrs: {
      src = null;
      nativeBuildInputs = [
        python.pkgs.pip
      ] ++ (lib.attrByPath [ "nativeBuildInputs" ] [] attrs);
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
        pip install --editable .

        set +v
      '';
    })
