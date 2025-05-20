{ config, pkgs, ... }:

# System24 (TUI style) Ayu Dark
{
  home.packages = with pkgs; [
    vesktop
  ];
  home.file.".config/vesktop/themes/system24-ayu-dark.theme.css".text = ''
    /**
    * @name system24 (ayu dark edit)
    * @description a tui-like discord theme with Ayu Dark colors.
    * @author refact0r
    */

    @import url("https://refact0r.github.io/system24/build/system24.css");

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
      --dms-icon-color-before: var(--icon-secondary);
      --dms-icon-color-after: var(--white);
      --custom-dms-background: off;
      --dms-background-image-url: url("");
      --dms-background-image-size: cover;
      --dms-background-color: linear-gradient(
        70deg,
        var(--blue-2),
        var(--purple-2),
        var(--red-2)
      );

      --background-image: off;
      --background-image-url: url("");

      --transparency-tweaks: off;
      --remove-bg-layer: off;
      --panel-blur: off;
      --blur-amount: 12px;
      --bg-floating: var(--bg-3);

      --small-user-panel: on;
      --unrounding: on;

      --custom-spotify-bar: on;
      --ascii-titles: on;
      --ascii-loader: system24;

      --panel-labels: on;
      --label-color: var(--text-muted);
      --label-font-weight: 500;
    }

    :root {
      --colors: on;

      /* Text colors */
      --text-0: #0f1419;
      --text-1: #f8f8f2;
      --text-2: #e6e1cf;
      --text-3: #c5c5c5;
      --text-4: #a0a0a0;
      --text-5: #5c6773;

      /* Backgrounds */
      --bg-1: #1b202a;
      --bg-2: #181c25;
      --bg-3: #131721;
      --bg-4: #0f1419;
      --hover: rgba(255, 255, 255, 0.05);
      --active: rgba(255, 255, 255, 0.1);
      --active-2: rgba(255, 255, 255, 0.15);
      --message-hover: var(--hover);

      /* Accent colors */
      --accent-1: #39bae6;
      --accent-2: #39bae6;
      --accent-3: #2aa2cd;
      --accent-4: #1c8bb3;
      --accent-5: #15799c;
      --mention: linear-gradient(
        to right,
        rgba(255, 204, 102, 0.1) 40%,
        transparent
      );
      --mention-hover: linear-gradient(
        to right,
        rgba(255, 204, 102, 0.2) 40%,
        transparent
      );
      --reply: linear-gradient(
        to right,
        rgba(255, 255, 255, 0.05) 40%,
        transparent
      );
      --reply-hover: linear-gradient(
        to right,
        rgba(255, 255, 255, 0.1) 40%,
        transparent
      );

      /* Status indicators */
      --online: #b8cc52;
      --dnd: #ff3333;
      --idle: #e6b94c;
      --streaming: #c792ea;
      --offline: #5c6773;

      /* Borders */
      --border-light: var(--hover);
      --border: var(--active);
      --border-hover: var(--accent-2);
      --button-border: rgba(255, 255, 255, 0.1);

      /* Red */
      --red-1: #ff6666;
      --red-2: #ff4c4c;
      --red-3: #ff3333;
      --red-4: #e62e2e;
      --red-5: #cc2929;

      /* Green */
      --green-1: #d2e685;
      --green-2: #b8cc52;
      --green-3: #a6b849;
      --green-4: #94a53f;
      --green-5: #829135;

      /* Blue */
      --blue-1: #a8d9f0;
      --blue-2: #7dcbe9;
      --blue-3: #39bae6;
      --blue-4: #2aa2cd;
      --blue-5: #1c8bb3;

      /* Purple (used for stream etc) */
      --purple-1: #d4bfff;
      --purple-2: #c792ea;
      --purple-3: #b480e3;
      --purple-4: #a16cd2;
      --purple-5: #8e58c1;

      /* Yellow */
      --yellow-1: #ffe291;
      --yellow-2: #ffcc66;
      --yellow-3: #e6b94c;
      --yellow-4: #cca633;
      --yellow-5: #b3931a;
    }
  '';
}