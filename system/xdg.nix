{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    #xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
