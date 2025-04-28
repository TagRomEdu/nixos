{
  config,
  pkgs,
  inputs,
  ...
}:

let
  allPackages = import ./packages.nix { inherit pkgs; };
in
{
  home.username = "lysec";
  home.homeDirectory = "/home/lysec";

  imports = [
#    ../../modules/niri/default.nix
    ../../modules/desktop/hyprland.nix

    ../../modules/desktop/hyprlock.nix
    ../../modules/desktop/waybar.nix
    ../../modules/desktop/swaync.nix
    ../../modules/desktop/walker.nix

    ../../modules/editors/vscode.nix
    ../../modules/editors/neovim.nix

    ../../modules/programs/ghostty.nix
    ../../modules/programs/fastfetch.nix
    ../../modules/programs/spicetify.nix
    ../../modules/programs/obs.nix
    ../../modules/programs/pywal-vesktop.nix

    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  xdg.portal.enable = true;

  home.stateVersion = "24.11";

  home.packages = allPackages;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
