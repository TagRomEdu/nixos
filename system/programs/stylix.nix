{ config, pkgs, lib, self, ... }:
{
  stylix.enable = true;
  stylix.autoEnable = true;
  #stylix.image = "${self}/assets/wallpapers/city.jpg";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  #stylix.base16Scheme = "${self}/assets/themes/levuaska.yaml";
}
