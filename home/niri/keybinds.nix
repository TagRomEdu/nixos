{ lib, config, pkgs, ... }:

let
  apps = import ./applications.nix { inherit pkgs; };

in {
  programs.niri.settings.binds = with config.lib.niri.actions; let
    pactl = "${pkgs.pulseaudio}/bin/pactl";

    volume-up = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
    volume-down = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
  in {

    # Quickshell Keybinds Start
    "super+Control+Return".action = spawn ["qs" "ipc" "call" "globalIPC" "toggleLauncher"];
    # Quickshell Keybinds End

    "xf86audioraisevolume".action = volume-up;
    "xf86audiolowervolume".action = volume-down;

    "control+super+xf86audioraisevolume".action = spawn "brightness" "up";
    "control+super+xf86audiolowervolume".action = spawn "brightness" "down";

    "super+q".action = close-window;
    "super+b".action = spawn apps.browser;
    "super+c".action = spawn "google-chrome-stable";
    "super+Return".action = spawn apps.terminal;
    #"super+Control+Return".action = spawn apps.appLauncher;
    "super+e".action = spawn apps.fileManager;

    "super+y".action = spawn apps.terminal -e "yazi";
    "super+g".action = spawn apps.terminal -e  "lazygit";
    "super+d".action = spawn apps.terminal -e  "lazydocker";

    "super+f".action = fullscreen-window;
    "super+t".action = toggle-window-floating;

    "control+shift+1".action = screenshot;
    "control+shift+2".action = screenshot-window { write-to-disk = true; };


    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-workspace-down;
    "super+Up".action = focus-workspace-up;

    "super+Shift+Left".action = move-column-left;
    "super+Shift+Right".action = move-column-right;
    "super+Shift+Down".action = move-column-to-workspace-down;
    "super+Shift+Up".action = move-column-to-workspace-up;

    "super+1".action = focus-workspace "browser";
    "super+2".action = focus-workspace "steam";

    "Mod+TouchpadScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 200; # задержка 200 мс между срабатываниями
    };

    "Mod+TouchpadScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 200;
    };

    "Mod+TouchpadScrollRight" = {
      action = focus-column-right;
      cooldown-ms = 200;
    };

    "Mod+TouchpadScrollLeft" = {
      action = focus-column-left;
      cooldown-ms = 200;
    };
  };
}
