{ lib, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = ["sh" "-c" "sleep 1 && waybar"]; }
    { command = ["systemctl" "--user" "start" "hyprpolkitagent"]; }
    { command = ["arrpc"]; }
    { command = ["swww-daemon"]; }
    { command = ["xwayland-satellite"]; }
    { command = ["waypaper" "--restore"]; }
    { command = ["swaync"]; }
    { command = ["vesktop"]; }
  ];
}
