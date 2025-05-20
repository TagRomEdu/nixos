{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprland.url = "github:hyprwm/Hyprland";
    niri.url = "github:sodiboo/niri-flake";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixvim.url = "github:nix-community/nixvim";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, nur, nixvim, quickshell, ... }@inputs: {

    # Expose NixOS configuration
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self inputs; };
      modules = [
        ./hosts/default/configuration.nix
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        inputs.spicetify-nix.nixosModules.default
        chaotic.nixosModules.default

        ({pkgs, ...}: {
          environment.systemPackages = [
            (quickshell.packages.${pkgs.system}.default.override {
              withWayland = true;
              withHyprland = true;
              withQtSvg = true;
            })
          ];
        })
      ];
    };
  };
}
