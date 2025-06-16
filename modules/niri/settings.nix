{
  config,
  pkgs,
  ...
}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {

      workspaces = {
        "browser" = {};
        "vesktop" = {};
      };
      
      prefer-no-csd = true;

      hotkey-overlay = {
          skip-at-startup = true;
      };

      layout = {
        border = {
          width = 3;
        };
        gaps = 6;
        struts = {
          left = 12;
          right = 12;
          top = 12;
          bottom = 12;
        };
      };

      input = {
        keyboard.xkb.layout = "de";
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

      # Output configuration (monitors)
      outputs = {
        "DP-1" = {
          mode = {
          width = 2560;
          height = 1440;
          refresh = 359.97900;
          };
          scale = 1.0;
          position = { x = 0; y = 0; };
          };
      };

      # Cursor configuration
      cursor = {
        size = 20;
        theme = "Adwaita";
      };

      # Environment
      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        #SDL_VIDEODRIVER = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1"; # enable, not disable, for performance

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
