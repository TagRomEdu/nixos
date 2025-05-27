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
    ../../modules/desktop/hyprland.nix
    ../../modules/quickshell/quickshell.nix
    ../../modules/desktop/hyprlock.nix
    ../../modules/desktop/walker.nix

    ../../modules/editors/vscode.nix
    ../../modules/editors/nixvim.nix

    ../../modules/programs/ghostty.nix
    ../../modules/programs/fastfetch.nix
    ../../modules/programs/spicetify.nix
    ../../modules/programs/obs.nix
    ../../modules/programs/vesktop.nix
    ../../modules/programs/firefox.nix

    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = allPackages;

  xdg.portal.enable = true;

  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable cliphist
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.home-manager.enable = true;
}
