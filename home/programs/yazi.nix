{ pkgs, config, ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      theme = "stylix";
    };
  };
}
