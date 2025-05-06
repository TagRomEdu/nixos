{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    niri.url = "github:sodiboo/niri-flake";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixvim.url = "github:nix-community/nixvim";

    fabric.url = "github:Fabric-Development/fabric";
  };

  outputs = { self, nixpkgs, home-manager, chaotic, nur, nixvim, fabric, ... }@inputs: {

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
      ];
    };

    # Expose Fabric packages for usage
    packages.x86_64-linux = {
      run-widget = fabric.packages.x86_64-linux.run-widget;  # Expose run-widget directly
    };

    # Optionally expose devShell for development
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = [
        nixpkgs.legacyPackages.x86_64-linux.python3
        fabric.packages.x86_64-linux.run-widget
      ];
    };
  };
}
