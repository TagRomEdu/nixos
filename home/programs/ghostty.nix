{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";

      theme = "stylix";

      window-decoration = false;

      window-opacity = 0.85;
      inactive-window-opacity = 0.6;

      # Disables ligatures
      font-feature = [
        "-liga"
        "-dlig"
        "-calt"
      ];
    };
  };
}
