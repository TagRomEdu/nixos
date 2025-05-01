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
    inputs.ags.homeManagerModules.default
  ];

  xdg.portal.enable = true;

  home.stateVersion = "24.11";

  home.packages = allPackages;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.ags = {
    enable = true;
    configDir = ../../modules/ags;  # or wherever you want to place your AGS config
  
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.hyprland
      inputs.ags.packages.${pkgs.system}.tray
      inputs.ags.packages.${pkgs.system}.mpris
      inputs.ags.packages.${pkgs.system}.wireplumber
      inputs.ags.packages.${pkgs.system}.bluetooth
      inputs.ags.packages.${pkgs.system}.powerprofiles
      inputs.ags.packages.${pkgs.system}.apps
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.notifd
      fzf
    ];
  
  };

  programs.home-manager.enable = true;
}
