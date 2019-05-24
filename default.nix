{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python36"
}:
  with pkgs;
  let
    python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs;
  in
    python.pkgs.buildPythonApplication {
      pname = "python-demo";
      version = "0.0.1";
      src = lib.cleanSourceWith {
        filter = (path: type:
          ! (builtins.any
              (r: (builtins.match r (builtins.baseNameOf path)) != null)
              [
                "pip_packages"
                ".*\.egg-info"
              ])
        );
        src = lib.cleanSource ./.;
      };
      nativeBuildInputs = [
        makeWrapper
      ];
      propagatedBuildInputs = (with python.pkgs; [
        numpy
      ]);
      checkInputs = (with python.pkgs; [
        pytest
      ]);
      checkPhase = ''
        pytest --capture=no tests --verbose
      '';
      postFixup = ''
        wrapProgram $out/bin/python-demo-external \
        --set PATH ${lib.makeBinPath [
          coreutils
        ]}
      '';
    }
