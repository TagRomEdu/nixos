{ config, pkgs, inputs, ... }:

{
  home.username = "lysec";
  home.homeDirectory = "/home/lysec";

  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    ../../modules/programs/spicetify.nix
    ../../modules/desktop/swaync.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/hyprlock.nix
    ../../modules/programs/ghostty.nix
  ];
  home.stateVersion = "24.11"; # Please read the comment before changing.
 
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.swaynotificationcenter

    pkgs.waybar
    pkgs.hyprshot
    pkgs.hyprlock
    pkgs.microfetch
    pkgs.vesktop
    pkgs.walker
    pkgs.vscodium
    pkgs.protonplus
    pkgs.imagemagick
    pkgs.nwg-look

    pkgs.tree
    pkgs.gh
    pkgs.rustup
    pkgs.gcc
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
}
