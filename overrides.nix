{ pkgs, pythonPath }:
  with pkgs;
  let
    pythonPath_ = lib.splitString "." pythonPath;
  in
    import path
    {
      overlays = [(
        self: super:
          lib.setAttrByPath
          pythonPath_
          (
            lib.getAttrFromPath (pythonPath_ ++ ["override"]) super
            {
              packageOverrides = self: super:
                {
                  matplotlib = super.matplotlib.override { enableQt = true; };
                };
            }
          )
      )];
    }
