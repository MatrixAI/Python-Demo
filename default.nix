{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python37",
  application ? false
}:
  let
    pkgs_ = import ./overrides.nix { inherit pkgs pythonPath; };
  in
    with pkgs_;
    let
      python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs_;
      build =
        if application
        then python.pkgs.buildPythonApplication
        else python.pkgs.buildPythonPackage;
    in
      let
        drv = { GPU_USE }: build rec {
          # GPU_USE is not intended for production use
          # it is a build-time parameter, that can be configured during development
          inherit GPU_USE;
          pname = "awesome-package";
          version = "0.0.1";
          src = nix-gitignore.gitignoreSource [] ./.;
          nativeBuildInputs = [
            makeWrapper
          ];
          propagatedBuildInputs = (with python.pkgs; [
            setuptools
            pillow
            numpy
            scipy
            scikitimage
            opencv3
            Keras
            h5py
            matplotlib
            dask
            distributed
            bokeh
            graphviz
            altair
            pandas
          ]);
          checkInputs = (with python.pkgs; [
            pytest
            pytestrunner
          ]);
          checkPhase = ''
            # unpacked source scripts needs hashbang paths patched
            patchShebangs bin
            pytest --capture=no tests --verbose
          '';
          makeWrapperArgs = [
            "--set GPU_USE ${GPU_USE}"
            "--set KERAS_BACKEND ${KERAS_BACKEND}"
            "--set MPLBACKEND ${MPLBACKEND}"
          ];
          KERAS_BACKEND = "tensorflow";
          MPLBACKEND = "Qt4Agg";
        };
      in
        {
          cpu = (drv { GPU_USE = "false"; }).overridePythonAttrs (attrs:
            {
              pname = "${attrs.pname}-cpu";
              propagatedBuildInputs =
                [
                  python.pkgs.tensorflowWithoutCuda
                ] ++ attrs.propagatedBuildInputs;
            }
          );
          gpu = (drv { GPU_USE = "true"; }).overridePythonAttrs (attrs:
            {
              pname = "${attrs.pname}-gpu";
              propagatedBuildInputs =
                [
                  python.pkgs.tensorflowWithCuda
                ] ++ attrs.propagatedBuildInputs;
              # cannot test on GPU builds because nix sandbox doesn't have access to the GPU
              doInstallCheck = false;
            }
          );
        }
