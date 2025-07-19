{ lib, pkgs, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = ["systemctl" "--user" "start" "hyprpolkitagent"]; }
    { command = ["arrpc"]; }
    { command = ["xwayland-satellite"]; }
    { command = ["qs"]; }
    { command = ["vesktop"]; }
    { command = ["swww-daemon"]; }
    #{ command = ["${pkgs.swaybg}/bin/swaybg" "-o" "DP-1" "-i" "/home/tre/nixos/assets/wallpapers/clouds.png" "-m" "fill"]; }
    #{ command = ["sh" "-c" "swww-daemon & swww img /home/tre/nixos/wallpapers/cloud.png"]; }
  ];
}
