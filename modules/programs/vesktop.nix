{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
  ];
  home.file.".config/vesktop/themes/system24-rosepine.theme.css".text = ''
    /**
    * @name system24 (rosé pine edit)
    * @description a tui-like discord theme with Rosé Pine colors.
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
      --dms-icon-color-after: var(--text-1);
      --custom-dms-background: off;
      --dms-background-image-url: url("");
      --dms-background-image-size: cover;
      --dms-background-color: linear-gradient(
        70deg,
        var(--rose),
        var(--iris),
        var(--love)
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

  /* Rosé Pine Palette */
  --base: #191724;
  --surface: #1f1d2e;
  --overlay: #26233a;
  --muted: #7e7a94; /* slightly brighter for better contrast */
  --subtle: #a8a4c2; /* more readable than original */
  --text: #f6f3ff;   /* brighter than #e0def4 */
  --love: #eb6f92;
  --gold: #f6c177;
  --rose: #ebbcba;
  --pine: #31748f;
  --foam: #9ccfd8;
  --iris: #c4a7e7;
  --highlight-low: #21202e;
  --highlight-med: #403d52;
  --highlight-high: #524f67;

  /* Text colors */
  --text-0: #000000;
  --text-1: var(--text);
  --text-2: var(--subtle);
  --text-3: var(--muted);
  --text-4: #5e5a70;
  --text-5: #4a4658;

  /* Backgrounds */
  --bg-1: var(--overlay);
  --bg-2: var(--surface);
  --bg-3: var(--base);
  --bg-4: var(--highlight-low);
  --hover: rgba(235, 111, 146, 0.08);
  --active: rgba(235, 111, 146, 0.15);
  --active-2: rgba(235, 111, 146, 0.2);
  --message-hover: var(--hover);


  /* Accent colors */
  --accent-1: var(--foam);
  --accent-2: var(--pine);
  --accent-3: var(--iris);
  --accent-4: var(--rose);
  --accent-5: var(--gold);

  --mention: linear-gradient(to right, rgba(246, 193, 119, 0.1) 40%, transparent);
  --mention-hover: linear-gradient(to right, rgba(246, 193, 119, 0.2) 40%, transparent);
  --reply: linear-gradient(to right, rgba(235, 111, 146, 0.08) 40%, transparent);
  --reply-hover: linear-gradient(to right, rgba(235, 111, 146, 0.15) 40%, transparent);

  /* Status indicators */
  --online: #9ccfd8;
  --dnd: #eb6f92;
  --idle: #f6c177;
  --streaming: #c4a7e7;
  --offline: #6e6a86;

  /* Borders (now using Rosé Pine `love`) */
  --border-light: #eb6f92;
  --border: #eb6f92;
  --border-hover: #eb6f92;
  --button-border: #eb6f92;

  /* Red (from love) */
  --red-1: #f08399;
  --red-2: #eb6f92;
  --red-3: #d45b7a;
  --red-4: #be4966;
  --red-5: #a93552;

  /* Green (from foam) */
  --green-1: #b1e3ed;
  --green-2: #9ccfd8;
  --green-3: #85bac3;
  --green-4: #6ea5ae;
  --green-5: #598f99;

  /* Blue (from pine) */
  --blue-1: #5c93ab;
  --blue-2: #4d8198;
  --blue-3: #3e6f85;
  --blue-4: #2f5d72;
  --blue-5: #204b5f;

  /* Purple (from iris) */
  --purple-1: #d9c2f0;
  --purple-2: #c4a7e7;
  --purple-3: #ae8cd3;
  --purple-4: #9971be;
  --purple-5: #8356aa;

  /* Yellow (from gold) */
  --yellow-1: #f8d3a6;
  --yellow-2: #f6c177;
  --yellow-3: #d6a05f;
  --yellow-4: #b68047;
  --yellow-5: #965f2f;
}

  '';
}
