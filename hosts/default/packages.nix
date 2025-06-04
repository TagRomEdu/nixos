{
  pkgs,
  ...
}:

with pkgs;
[
  # Applications
  protonplus
  lutris
  dolphin-emu
  prismlauncher
  heroic
  peazip

  # TUI
  btop
  yazi

  # Desktop
  hyprlock
  nwg-look
  walker

  # Development
  nodejs
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
  nvd
  wl-clipboard
  pywalfox-native
  imagemagick
  amdvlk
  rar
  unzip
  droidcam
  gowall
  gruvbox-gtk-theme
  papirus-icon-theme
  qt6Packages.qt5compat
  #kdePackages.syntax-highlighting
  grimblast
  gpu-screen-recorder
  mpv
  slop
]

