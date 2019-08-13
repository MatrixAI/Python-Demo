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
        config = {
          Cmd = [];
        };
      };
    }
