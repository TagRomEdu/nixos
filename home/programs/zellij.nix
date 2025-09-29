{ pkgs, config, ... }:
{
  programs.zellij = {
    enable = true;

    settings = {
      theme = "stylix";

      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";
    };
  };
}
