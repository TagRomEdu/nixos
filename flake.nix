{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fabric.url = "github:Fabrics-Development/fabric";  # Add the Fabric flake
  };

  outputs = { self, nixpkgs, home-manager, chaotic, fabric, ... }@inputs: {
    # Define the NixOS configuration for your system
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

    # Fabric overlay setup and package definitions for Python packages
    nixpkgs.lib.eachDefaultSystem (system: let
      overlay = final: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions ++ [
            (python-final: python-prev: {
              python-fabric = prev.callPackage fabric.default {};
            })
          ];
      };

      pkgs = nixpkgs.legacyPackages.${system}.extend overlay;
    in {
      overlays.default = overlay;

      # Fabric's Python package and run-widget
      packages = {
        default = pkgs.python3Packages.python-fabric;
        run-widget = pkgs.callPackage fabric.run-widget {};
      };

      # Reference the devShell from the dev-shells folder
      devShells = {
        default = import ./dev-shells/fabric-shell.nix { pkgs = pkgs; python3 = pkgs.python3; };
      };
    });
  };
}
