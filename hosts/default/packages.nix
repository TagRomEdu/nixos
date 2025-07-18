{
  pkgs,
  ...
}:

with pkgs;
[
  # Applications
  protonplus
  lutris
  prismlauncher
  heroic
  nautilus
  file-roller
  obsidian

  # TUI
  btop

  # Desktop
  nwg-look
  walker

  # Development
  rustup
  gcc
  gh
  nixfmt-rfc-style
  nixpkgs-fmt
  black

  # Utilities
  jq
  socat
  tree
  libnotify
  wl-clipboard
  pywalfox-native
  imagemagick
  amdvlk
  rar
  unzip
  droidcam
  gpu-screen-recorder
  mpv
  cava
  
  # Quickshell stuff
  qt6Packages.qt5compat
  libsForQt5.qt5.qtgraphicaleffects
  kdePackages.qtbase
  kdePackages.qtdeclarative
  kdePackages.qtstyleplugin-kvantum
  wallust

  # Niri
  xwayland-satellite
  wl-clipboard
]

