{ lib, config, pkgs, ... }:

{
  programs.niri.settings.binds = with config.lib.niri.actions; let
    pactl = "${pkgs.pulseaudio}/bin/pactl";

    volume-up = spawn "${pactl}" "set-sink-volume" "@DEFAULT_SINK@" "+5%";
    volume-down = spawn "${pactl}" "set-sink-volume" "@DEFAULT_SINK@" "-5%";

    hyprshot-region = spawn "hyprshot" "-m" "-region" "--clipboard-only";
    
  in {
    "xf86audioraisevolume".action = volume-up;
    "xf86audiolowervolume".action = volume-down;

    # Other keybinds (unchanged)
    "super+q".action = close-window;
    "super+b".action = spawn "firefox";
    "super+Return".action = spawn "ghostty";
    "super+Control+Return".action = spawn "walker";
    "super+f".action = fullscreen-window;
    "super+t".action = toggle-window-floating;

    "control+shift+1".action = spawn "${pkgs.hyprshot}/bin/hyprshot" "-m" "region" "--clipboard-only";
    "control+shift+2".action = spawn "${pkgs.hyprshot}/bin/hyprshot" "-m" "window" "--clipboard-only";
    "control+shift+3".action = spawn "${pkgs.hyprshot}/bin/hyprshot" "-m" "output" "--clipboard-only";

    # Screenshots
    "super+Control+1".action = hyprshot-region;

    # Focus navigation
    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-workspace-down;
    "super+Up".action = focus-workspace-up;

    "super+Shift+Left".action = move-column-left;
    "super+Shift+Right".action = move-column-right;
    "super+Shift+Down".action = move-column-to-workspace-down;
    "super+Shift+Up".action = move-column-to-workspace-up;
  };
}