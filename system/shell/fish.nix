# fish.nix or configuration.nix
{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = "
      cat ~/.cache/wal/sequences
      set -g fish_greeting ''
      fastfetch
    ";

    shellAliases = {
      ll = "ls -la";
    };
  };
}
