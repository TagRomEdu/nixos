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
  #cat ~/.cache/wal/sequences <- if I want to go back to pywal
    interactiveShellInit = "
      
      set -g fish_greeting ''
      swiftfetch
    ";

    shellAliases = {
      ll = "ls -la";
    };
  };
}
