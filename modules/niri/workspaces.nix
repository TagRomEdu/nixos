{ lib, config, pkgs, ... }:
{
  programs.niri.settings = {
    workspaces = {
      "browser" = {
        open-on-output = "DP-1";
      };
      "chat" = {
        open-on-output = "DP-1";  # Adjust to your actual output name
      };
    };

    window-rules = [
      {
        matches = {
          app-id = "com.electron.vesktop";  # Try also "vesktop" if this doesn't match
        };
        open-on-workspace = "chat";
      }
    ];
  };
}