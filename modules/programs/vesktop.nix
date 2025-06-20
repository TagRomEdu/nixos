{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "vesktop";

      runtimeInputs = [ vesktop ]; # depend on the real vesktop binary

      text = ''
        if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
          exec vesktop --ozone-platform=x11 "$@"
        else
          exec vesktop "$@"
        fi
      '';
    })
  ];

  home.file.".config/vesktop/themes/system24-noktis.theme.css".text = ''
  /**
  * @name system24 (Noktis)
  * @description Base16-aligned OLED-optimized TUI-style theme for Discord via Vesktop.
  * @author refact0r
  */

  @import url("https://refact0r.github.io/system24/build/system24.css");

  .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr,
  .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
    color: var(--base06) !important;
  }

  /* Unread channel styling */
  .containerDefault-3GGEv_ .unread-36eUEm {
    background-color: var(--base0E) !important;
    opacity: 0.3;
  }

  .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr {
    color: var(--base05) !important;
    font-weight: 500;
  }

  .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
    color: var(--base05) !important;
  }

  /* Unread mentions styling */
  .containerDefault-3GGEv_ .unread-36eUEm .mentionsBadge-3HnHJv {
    background-color: var(--base0E) !important;
    color: var(--base05) !important;
  }

  /* Force OLED background everywhere */
  .theme-dark,
  .theme-light,
  :root {
    --background-primary: #141414 !important;
    --background-secondary: #141414 !important;
    --background-secondary-alt: #141414 !important;
    --background-tertiary: #141414 !important;
    --background-mobile-primary: #141414 !important;
    --background-mobile-secondary: #141414 !important;
    --deprecated-card-bg: #141414 !important;
    --deprecated-store-bg: #141414 !important;
    --background-floating: #141414 !important;
    --bg-overlay-1: #141414 !important;
    --bg-overlay-2: #141414 !important;
    --bg-overlay-3: #141414 !important;
    --bg-overlay-4: #141414 !important;
    --bg-overlay-5: #141414 !important;
    --bg-overlay-6: #141414 !important;
    --bg-base: #141414 !important;
    --bg-primary: #141414 !important;
    --bg-secondary: #141414 !important;
  }

  /* Force background color on specific elements */
  .appMount-2yBXZl,
  .app-2CXKsg,
  .bg-1QIAus,
  .container-1eFtFS,
  .wrapper-3HVHpV,
  .scroller-3X7KbA,
  .layer-86YKbF,
  .container-2cd8Mz,
  .chat-2ZfjoI,
  .container-2o3qEW,
  .applicationStore-2nk7Lo,
  .pageWrapper-2PwDoS,
  .standardSidebarView-E9Pc3j,
  .contentRegion-3HkfJJ {
    background-color: #141414 !important;
  }

  body {
    --font: "JetBrains Mono";
    --code-font: "JetBrains Mono";
    font-weight: 300;
    letter-spacing: -0.05ch;

    --gap: 12px;
    --divider-thickness: 4px;
    --border-thickness: 2px;
    --border-hover-transition: 0.2s ease;

    --animations: on;
    --list-item-transition: 0.2s ease;
    --dms-icon-svg-transition: 0.4s ease;

    --top-bar-height: var(--gap);
    --top-bar-button-position: titlebar;
    --top-bar-title-position: off;
    --subtle-top-bar-title: off;

    --custom-window-controls: off;
    --window-control-size: 14px;

    --custom-dms-icon: off;
    --dms-icon-svg-url: url("");
    --dms-icon-svg-size: 90%;
    --dms-icon-color-before: var(--base03);
    --dms-icon-color-after: var(--base05);
    --custom-dms-background: off;

    --background-image: off;
    --background-image-url: url("");
    --transparency-tweaks: off;
    --remove-bg-layer: off;
    --panel-blur: off;
    --blur-amount: 12px;

    --bg-floating: var(--base01);
    --small-user-panel: on;
    --unrounding: on;
    --custom-spotify-bar: on;
    --ascii-titles: on;
    --ascii-loader: system24;

    --panel-labels: on;
    --label-color: var(--base04);
    --label-font-weight: 500;

    background-color: var(--base00) !important;
  }

  :root {
    /* Base16 OLED Theme - Matched from Colors.qml with reduced saturation */
    --base00: #141414; /* Background */
    --base01: #141414; /* Panels */
    --base02: #1a1a1a; /* Selections / overlays */
    --base03: #4a4a4a; /* Comments / borders */
    --base04: #808080; /* Secondary text */
    --base05: #b0b0b0; /* Primary text - adjusted to be less bright */
    --base06: #e0e0e0; /* Bright text */
    --base07: #f0f0f0; /* Brightest text */
    --base08: #d0606e; /* Red / errors */
    --base09: #d5896f; /* Orange / warnings */
    --base0A: #d5b767; /* Yellow / highlights */
    --base0B: #7cbf6e; /* Green / success */
    --base0C: #69cac8; /* Cyan / info */
    --base0D: #7696dc; /* Blue / primary */
    --base0E: #a478dc; /* Purple / accents */
    --base0F: #a478dc; /* Pink / special */

    /* Text mappings */
    --text-1: var(--base04);
    --text-2: var(--base04);
    --text-3: var(--base05);
    --text-muted: var(--base04);

    /* Backgrounds - Updated for consistent base00 usage */
    --bg-1: var(--base01);
    --bg-2: var(--base01);
    --bg-3: var(--base00);
    --bg-4: var(--base01);
    --bg-overlay: var(--base00);
    --bg-app: var(--base00);
    --bg-base: var(--base00);
    --bg-primary: var(--base00);
    --background-primary: var(--base00);
    --background-secondary: var(--base01);
    --background-secondary-alt: var(--base01);
    --background-tertiary: var(--base00);
    --background-accent: var(--base0E);
    --background-modifier-hover: var(--base01);
    --background-modifier-active: var(--base02);
    --background-modifier-selected: var(--base02);
    --background-floating: var(--base01);

    /* UI states - Reduced opacity for OLED */
    --hover: rgba(164, 120, 220, 0.06);
    --active: rgba(164, 120, 220, 0.12);
    --active-2: rgba(164, 120, 220, 0.15);
    --message-hover: var(--hover);

    /* Accents */
    --accent-1: var(--base0C);
    --accent-2: var(--base0B);
    --accent-3: var(--base0E);
    --accent-4: var(--base0E);
    --accent-5: var(--base0F);

    /* Mentions & replies - Reduced opacity */
    --mention: linear-gradient(to right, rgba(213, 137, 111, 0.08) 40%, transparent);
    --mention-hover: linear-gradient(to right, rgba(213, 137, 111, 0.12) 40%, transparent);
    --reply: linear-gradient(to right, rgba(208, 96, 110, 0.06) 40%, transparent);
    --reply-hover: linear-gradient(to right, rgba(208, 96, 110, 0.1) 40%, transparent);

    /* Presence indicators */
    --online: var(--base0C);
    --dnd: var(--base08);
    --idle: var(--base09);
    --streaming: var(--base0E);
    --offline: var(--base03);

    /* Borders */
    --border: var(--base0E);
    --border-hover: var(--base0E);
    --button-border: var(--base0E);

    /* Color variants - Toned down for OLED */
    --red-1: #d6a0ad;
    --red-2: var(--base08);
    --red-3: #bc5a68;
    --red-4: #a64452;
    --red-5: #8a2e3c;

    --green-1: #96cf9b;
    --green-2: var(--base0B);
    --green-3: #63a962;
    --green-4: #4a9346;
    --green-5: #317d2a;

    --blue-1: #94bef3;
    --blue-2: var(--base0D);
    --blue-3: #5a81d3;
    --blue-4: #3e68bb;
    --blue-5: #224fa2;

    --purple-1: var(--base0E);
    --purple-2: var(--base0E);
    --purple-3: #956bd2;
    --purple-4: #7741b9;
    --purple-5: #5927a0;

    --yellow-1: #dae59a;
    --yellow-2: var(--base0A);
    --yellow-3: #b8ba4f;
    --yellow-4: #9b8d37;
    --yellow-5: #7e701f;
  }
'';

home.file.".config/vesktop/themes/system24-gruv-material.theme.css".text = ''
    /**
  * @name system24 (Gruv-Material, Base16)
  * @description Base16-aligned Gruv-Material TUI-style theme for Discord via Vesktop.
  * @author refact0r
  */
  @import url("https://refact0r.github.io/system24/build/system24.css");

  .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr,
  .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
    color: var(--base06) !important;
  }

  .containerDefault-3GGEv_ .unread-36eUEm {
    background-color: var(--base0E) !important;
    opacity: 0.3;
  }

  .containerDefault-3GGEv_ .unread-36eUEm .name-3Uvkvr {
    color: var(--base05) !important;
    font-weight: 500;
  }

  .containerDefault-3GGEv_ .unread-36eUEm .icon-3AqZ2e {
    color: var(--base05) !important;
  }

  .containerDefault-3GGEv_ .unread-36eUEm .mentionsBadge-3HnHJv {
    background-color: var(--base0E) !important;
    color: var(--base05) !important;
  }

  .theme-dark,
  .theme-light,
  :root {
    --background-primary: #141617 !important;
    --background-secondary: #141617 !important;
    --background-secondary-alt: #141617 !important;
    --background-tertiary: #141617 !important;
    --background-mobile-primary: #141617 !important;
    --background-mobile-secondary: #141617 !important;
    --deprecated-card-bg: #141617 !important;
    --deprecated-store-bg: #141617 !important;
    --background-floating: #141617 !important;
    --bg-overlay-1: #141617 !important;
    --bg-overlay-2: #141617 !important;
    --bg-overlay-3: #141617 !important;
    --bg-overlay-4: #141617 !important;
    --bg-overlay-5: #141617 !important;
    --bg-overlay-6: #141617 !important;
    --bg-base: #141617 !important;
    --bg-primary: #141617 !important;
    --bg-secondary: #141617 !important;
  }

  .appMount-2yBXZl,
  .app-2CXKsg,
  .bg-1QIAus,
  .container-1eFtFS,
  .wrapper-3HVHpV,
  .scroller-3X7KbA,
  .layer-86YKbF,
  .container-2cd8Mz,
  .chat-2ZfjoI,
  .container-2o3qEW,
  .applicationStore-2nk7Lo,
  .pageWrapper-2PwDoS,
  .standardSidebarView-E9Pc3j,
  .contentRegion-3HkfJJ {
    background-color: #141617 !important;
  }

  body {
    --font: "JetBrains Mono";
    --code-font: "JetBrains Mono";
    font-weight: 300;
    letter-spacing: -0.05ch;

    --gap: 12px;
    --divider-thickness: 4px;
    --border-thickness: 2px;
    --border-hover-transition: 0.2s ease;

    --animations: on;
    --list-item-transition: 0.2s ease;
    --dms-icon-svg-transition: 0.4s ease;

    --top-bar-height: var(--gap);
    --top-bar-button-position: titlebar;
    --top-bar-title-position: off;
    --subtle-top-bar-title: off;

    --custom-window-controls: off;
    --window-control-size: 14px;

    --custom-dms-icon: off;
    --dms-icon-svg-url: url("");
    --dms-icon-svg-size: 90%;
    --dms-icon-color-before: var(--base03);
    --dms-icon-color-after: var(--base05);
    --custom-dms-background: off;

    --background-image: off;
    --background-image-url: url("");
    --transparency-tweaks: off;
    --remove-bg-layer: off;
    --panel-blur: off;
    --blur-amount: 12px;

    --bg-floating: var(--base01);
    --small-user-panel: on;
    --unrounding: on;
    --custom-spotify-bar: on;
    --ascii-titles: on;
    --ascii-loader: system24;

    --panel-labels: on;
    --label-color: var(--base04);
    --label-font-weight: 500;

    background-color: var(--base00) !important;
  }

  :root {
    --base00: #141617;
    --base01: #1d2021;
    --base02: #282828;
    --base03: #504945;
    --base04: #7c6f64;
    --base05: #d4be98;
    --base06: #ddc7a1;
    --base07: #f7f9ff;
    --base08: #ea6962;
    --base09: #e78a4e;
    --base0A: #d8a657;
    --base0B: #a9b665;
    --base0C: #89b482;
    --base0D: #7daea3;
    --base0E: #d3869b;
    --base0F: #a89984;

    --text-1: var(--base04);
    --text-2: var(--base04);
    --text-3: var(--base05);
    --text-muted: var(--base04);

    --bg-1: var(--base00);
    --bg-2: var(--base00);
    --bg-3: var(--base00);
    --bg-4: var(--base00);
    --bg-overlay: var(--base00);
    --bg-app: var(--base00);
    --bg-base: var(--base00);
    --bg-primary: var(--base00);
    --background-primary: var(--base00);
    --background-secondary: var(--base01);
    --background-secondary-alt: var(--base01);
    --background-tertiary: var(--base00);
    --background-accent: var(--base0E);
    --background-modifier-hover: var(--base01);
    --background-modifier-active: var(--base02);
    --background-modifier-selected: var(--base02);
    --background-floating: var(--base01);

    --hover: rgba(211, 134, 155, 0.06);
    --active: rgba(211, 134, 155, 0.12);
    --active-2: rgba(211, 134, 155, 0.15);
    --message-hover: var(--hover);

    --accent-1: var(--base0C);
    --accent-2: var(--base0B);
    --accent-3: var(--base0E);
    --accent-4: var(--base0E);
    --accent-5: var(--base0F);

    --mention: linear-gradient(to right, rgba(231, 138, 78, 0.08) 40%, transparent);
    --mention-hover: linear-gradient(to right, rgba(231, 138, 78, 0.12) 40%, transparent);
    --reply: linear-gradient(to right, rgba(234, 105, 98, 0.06) 40%, transparent);
    --reply-hover: linear-gradient(to right, rgba(234, 105, 98, 0.1) 40%, transparent);

    --online: var(--base0C);
    --dnd: var(--base08);
    --idle: var(--base09);
    --streaming: var(--base0E);
    --offline: var(--base03);

    --border: var(--base0E);
    --border-hover: var(--base0E);
    --button-border: var(--base0E);

    --red-1: #f29ca0;
    --red-2: var(--base08);
    --red-3: #d26a6e;
    --red-4: #b14549;
    --red-5: #902f30;

    --green-1: #c3db97;
    --green-2: var(--base0B);
    --green-3: #99b759;
    --green-4: #799645;
    --green-5: #59752f;

    --blue-1: #a7d3d2;
    --blue-2: var(--base0D);
    --blue-3: #84bab8;
    --blue-4: #609f9b;
    --blue-5: #3d8380;

    --purple-1: var(--base0E);
    --purple-2: var(--base0E);
    --purple-3: #c271a4;
    --purple-4: #a45287;
    --purple-5: #843469;

    --yellow-1: #e7d6a3;
    --yellow-2: var(--base0A);
    --yellow-3: #c8b057;
    --yellow-4: #a9933f;
    --yellow-5: #8a7627;
  }
  '';
}
