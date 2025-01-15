{ pkgs, ... }:

let
  vscodeExtensions = with pkgs.vscodeExtensions; [
    # Add the Nix extension for code highlighting
    nix
    vscode-icons
    ms-vscode.cpptools
  ];
in
{
  environment.systemPackages = with pkgs; [
    vscodium
  ];

  # Installing the extensions
  programs.vscode = {
    enable = true;
    extensions = vscodeExtensions;
  };
}
