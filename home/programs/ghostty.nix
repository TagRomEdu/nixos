{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";

      theme = "stylix";

      window-decoration = false;

      background-opacity = 0.75;

      # Disables ligatures
      font-feature = [
        "-liga"
        "-dlig"
        "-calt"
      ];
    };
  };
}
