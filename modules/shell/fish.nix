# fish.nix or configuration.nix
{ pkgs, config, lib, ... }:

{
  programs.fish = {
    enable = true;

    # Disable Fish greeting by overriding fish_greeting
    interactiveShellInit = "
      cat ~/.cache/wal/sequences
      set -g fish_greeting ''
      fastfetch
    ";

    # Optional: add more customization like shell aliases
    shellAliases = {
      ll = "ls -la";
    };
  };
}
