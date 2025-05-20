{ config, lib, pkgs, ... }:

let
  quickshellDir = "${config.home.homeDirectory}/nixos/modules/quickshell";
  targetDir = "${config.home.homeDirectory}/.config/quickshell";
in {
  home.activation.symlinkQuickshell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn "${quickshellDir}" "${targetDir}"
  '';
}
