{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python37"
}:
  with pkgs;
  let
    drvs = import ./default.nix { inherit pkgs pythonPath; application = true; };
  in
    {
      docker-cpu = dockerTools.buildImage {
        name = drvs.cpu.pname;
        contents = drvs.cpu;
        runAsRoot = ''
          #!${runtimeShell}
          mkdir /tmp
          chmod 1777 /tmp
        '';
      };
      docker-gpu = dockerTools.buildImage {
        name = drvs.gpu.pname;
        contents = drvs.gpu;
        runAsRoot = ''
          #!${runtimeSHell}
          mkdir /tmp
          chmod 1777 /tmp
        '';
        config = {
          Env = [
            "NVIDIA_DRIVER_CAPABILITIES=compute"
            "NVIDIA_VISIBLE_DEVICES=all"
            "LD_LIBRARY_PATH=/usr/lib64"
          ];
        };
      };
    }
