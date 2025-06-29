{ lib, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = ["systemctl" "--user" "start" "hyprpolkitagent"]; }
    { command = ["arrpc"]; }
    { command = ["xwayland-satellite"]; }
    { command = ["qs"]; }
    { command = ["vesktop"]; }
  ];
}
