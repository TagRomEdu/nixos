{
  config,
  pkgs,
  inputs,
  self,
  ...
}:

let
  allPackages = import ./packages.nix { inherit pkgs; };
in
{
  home.username = "lysec";
  home.homeDirectory = "/home/lysec";

  imports = [
    ../../modules/niri/default.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/quickshell/quickshell.nix
    ../../modules/desktop/hyprlock.nix
    ../../modules/desktop/hypridle.nix
    ../../modules/desktop/walker.nix

    ../../modules/editors/vscode.nix
    ../../modules/editors/nixvim.nix

    ../../modules/programs/ghostty.nix
    ../../modules/programs/fastfetch.nix
    ../../modules/programs/spicetify.nix
    ../../modules/programs/obs.nix
    ../../modules/programs/vesktop.nix
    ../../modules/programs/firefox.nix

    ../../system/shell/zsh.nix

    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    ../../modules/matugen/matugen.nix  # <- Add your matugen module here
  ];

  home.packages = allPackages;

  xdg.portal.enable = true;

  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.home-manager.enable = true;

  # Minimal matugen enable and config:
  programs.matugen = {
    enable = true;
    variant = "dark";
    source_color = "#7f5af0";  # example hex color to generate theme from
    wallpaper = "${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
  };
}