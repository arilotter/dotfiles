{
  description = "ari's nice lil nix config :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-ext = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-colors, ... }@inputs: {
    # `sudo nixos-rebuild switch --flake .#luna`
    nixosConfigurations = {
      # desktop ~
      "luna" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit nix-colors; };
        modules = [ ./nixos/luna/configuration.nix ];
      };
    };

    # `home-manager switch --flake .#ari@luna`
    homeConfigurations = {
      "ari@luna" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; inherit nix-colors; };
        modules = [
          inputs.hyprland.homeManagerModules.default
          inputs.nix-colors.homeManagerModules.default
          inputs.gBar.homeManagerModules.x86_64-linux.default
          ./home-manager/home.nix
        ];
      };
    };
  };
}
