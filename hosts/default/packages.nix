{ pkgs, ... }:
with pkgs;
[

  # Applications
  firefox
  #(vesktop.override { electron = pkgs.electron_33; })
  vesktop
  #(discord-canary.override { withVencord = true; })
  protonplus
  lutris
  furmark
  dolphin-emu

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
  amdvlk
]
