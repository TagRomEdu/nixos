{ config, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      workspaces = {
        "prime" = {};
        "cli" = {};

        "browser" = {};
        "steam" = {};

        "other" = {};
      };

      prefer-no-csd = true;

      hotkey-overlay = {
        skip-at-startup = true;
      };

      layout = {

        background-color = "#00000000";

        focus-ring = {
          enable = true;
          width = 3;
          active = {
            color = "#A8AEFF";
          };
          inactive = {
            color = "#505050";
          };
        };

        gaps = 6;

        struts = {
          left = 20;
          right = 20;
          top = 20;
          bottom = 20;
        };
      };

      input = {
        keyboard.xkb.layout = "us,ru";
        keyboard.xkb.options = "grp:win_space_toggle";
        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = false;
      };

      outputs = {
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          scale = 1.0;
          position = { x = 0; y = 0; };
          focus-at-startup.enable = true;
        };
        
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          scale = 1.2;
          position = { x = 0; y = 1080; };
        };
      };

      cursor = {
        size = 20;
        theme = "Adwaita";
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
