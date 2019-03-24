{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python36"
}:
  let
    pkgs_ = import ./overrides.nix { inherit pkgs pythonPath; };
  in
    with pkgs_;
    let
      python = lib.getAttrFromPath (lib.splitString "." pythonPath) pkgs_;
    in
      let
        drv = { GPU_USE }: python.pkgs.buildPythonApplication rec {
          # GPU_USE is not intended for production use
          # it is a build-time parameter, that can be configured during development
          inherit GPU_USE;
          pname = "awesome-package";
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
          buildInputs = [
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
          cpu = (drv { GPU_USE = "false"; }).overrideAttrs (attrs:
            {
              pname = "${attrs.pname}-cpu";
              propagatedBuildInputs =
                [
                  python.pkgs.tensorflowWithoutCuda
                ] ++ attrs.propagatedBuildInputs;
            }
          );
          gpu = (drv { GPU_USE = "true"; }).overrideAttrs (attrs:
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
