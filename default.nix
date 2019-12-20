{ buildPythonPackage
, nix-gitignore
, makeWrapper
, numpy
, coreutils
, pytest
, pytestrunner
, lib
}:

buildPythonPackage {
  pname = "python-demo";
  version = "0.0.1";
  src = nix-gitignore.gitignoreSource [] ./.;
  nativeBuildInputs = [
    makeWrapper
  ];
  propagatedBuildInputs = [
    numpy
  ];
  checkInputs = [
    pytest
  ];
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
