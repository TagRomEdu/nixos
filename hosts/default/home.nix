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
    "${self}/modules/desktop/hyprland.nix"
    "${self}/modules/desktop/hyprlock.nix"
    "${self}/modules/desktop/waybar.nix"
    "${self}/modules/desktop/swaync.nix"

    "${self}/modules/programs/spicetify.nix"
    "${self}/modules/editors/vscode.nix"
    "${self}/modules/programs/ghostty.nix"
    "${self}/modules/programs/fastfetch.nix"

    "${self}/modules/editors/neovim.nix"

    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.stateVersion = "24.11";

  home.packages = allPackages;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
