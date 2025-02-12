{ pkgs }:
with pkgs;
[

  # Applications
  firefox
  # vesktop
  (discord-canary.override { withVencord = true; })
  protonplus
  lutris
  furmark

  # Desktop
  swaynotificationcenter
  waybar
  hyprshot
  hyprlock
  walker
  nwg-look

  # Development
  rustup
  gcc
  gh
  nixfmt-rfc-style
  nixpkgs-fmt
  black

  # Utilities
  tree
  libnotify
  nvd
  wl-clipboard
  pywalfox-native
  imagemagick
]
