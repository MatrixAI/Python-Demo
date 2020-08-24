{ buildPythonPackage
, nix-gitignore
, numpy
, coreutils
, pytest
, pytestrunner
}:

buildPythonPackage {
  pname = "python-demo";
  version = "0.0.1";
  src = nix-gitignore.gitignoreSource [] ./.;
  propagatedBuildInputs = [
    numpy
  ];
  checkInputs = [
    pytest
    pytestrunner
  ];
  checkPhase = ''
    pytest --capture=no --verbose tests
  '';
}
