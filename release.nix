{
  pkgs ? import ./pkgs.nix,
  pythonPath ? "python37"
}:
  with pkgs;
  let
    drv = import ./default.nix { inherit pkgs pythonPath; application = true; };
  in
    {
      docker = dockerTools.buildImage {
        name = drv.pname;
        contents = drv;
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
