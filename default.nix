{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python37",
  application ? false
}:
  with pkgs;
  let
    python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs;
    build =
      if application
      then python.pkgs.buildPythonApplication
      else python.pkgs.buildPythonPackage;
  in
    build {
      pname = "python-demo";
      version = "0.0.1";
      src = nix-gitignore.gitignoreSource [] ./.;
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
