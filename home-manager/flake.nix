{
  description = "Home Manager configuration of ari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:arilotter/home-manager/fix-fish";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    e = {
      url = "github:hyprwm/contrib";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, hyprland, e, gBar, nix-colors, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."ari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          hyprland.homeManagerModules.default
          nix-colors.homeManagerModules.default
          gBar.homeManagerModules.x86_64-linux.default
          ./home.nix
        ];

        extraSpecialArgs = {
          inherit nix-colors;
          inherit e;
        };
      };
    };
}
