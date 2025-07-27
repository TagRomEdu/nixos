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

    "control+super+TouchpadScrollUp".action = spawn "brightness" "down";
    "control+super+TouchpadScrollDown".action = spawn "brightness" "up";
    "control+super+TouchpadScrollLeft".action = volume-up;
    "control+super+TouchpadScrollRight".action = volume-down;
 
    "super+q".action = close-window;

    "super+b".action = spawn apps.browser;
    "super+c".action = spawn "google-chrome-stable";
    "super+Return".action = spawn apps.terminal;
    #"super+Control+Return".action = spawn apps.appLauncher;
    "super+e".action = spawn apps.fileManager;

    "super+y".action = spawn [ "${apps.terminal}" "-e" "yazi" ];
    "super+g".action = spawn [ "${apps.terminal}" "-e" "lazygit" ];
    "super+d".action = spawn [ "${apps.terminal}" "-e" "lazydocker" ];

    "super+f".action = fullscreen-window;
    "super+t".action = toggle-window-floating;

    
    # Move/Resize floating windows
    #"super+Alt+Left".action = resize-window-left;
    #"super+Alt+Right".action = resize-window-right;
    #"super+Alt+Up".action = resize-window-up;
    #"super+Alt+Down".action = resize-window-down;

    #"super+Ctrl+Left".action = move-window-left;
    #"super+Ctrl+Right".action = move-window-right;
    #"super+Ctrl+Up".action = move-window-up;
    #"super+Ctrl+Down".action = move-window-down;

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
  };
}
