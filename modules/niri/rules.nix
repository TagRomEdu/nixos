{ lib, pkgs, ... }:

let
  windowRules = [
    {
      matches = [
        { app-id = "steam"; }
      ];
      workspace = 3;
      floating = true;
    }
    {
      matches = [ { app-id = "vesktop"; } ];
      padding = 0;
      border = true;
      floating = false;
      opaque = true; # <--- important
      extend-border = false; # <--- new important thing
    }
    # Add other rules here as needed
  ];
in {
  programs.niri = {
    enable = true;
    settings = {
      windowRules = windowRules;  # Correct location
      # Additional settings
    };
  };
}
