{
  description = "ari's nice lil nix config :3";

  nixConfig = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "ari-sol-builder-1:PBsq1rU3Xd/S+N3GatIWi82PFoeOqQdpaArZTns69aM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

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

    beepy = {
      url = "github:arilotter/nixos-beepy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fido2-hid-bridge = {
      url = "github:arilotter/fido2-hid-bridge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-colors, ... }@inputs: rec {
    nixosConfigurations = {
      # desktop ~
      # `sudo nixos-rebuild switch --flake .#luna`
      "luna" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit nix-colors; };
        modules = [
          inputs.fido2-hid-bridge.nixosModule
          ./nixos/all-systems-configuration.nix
          ./nixos/graphical-configuration.nix
          ./nixos/luna/hardware-configuration.nix
          ./nixos/luna/configuration.nix
        ];
      };

      # linux lappy
      # `sudo nixos-rebuild switch --flake .#sol`
      "sol" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit nix-colors; };
        modules = [
          ./nixos/all-systems-configuration.nix
          ./nixos/graphical-configuration.nix
          ./nixos/sol/hardware-configuration.nix
          ./nixos/sol/configuration.nix
        ];
      };

      # kronos = saturn = cuz it rings ;)
      # locally: `sudo nixos-rebuild switch --flake .#kronos`
      # sd image: `nix build '.#kronos-sd'`
      # from `sol`: `NIX_SSHOPTS="-t" nixos-rebuild boot --flake .#kronos -L --target-host ari@kronos.local --use-remote-sudo`
      "kronos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit nix-colors; };
        modules = [
          inputs.beepy.nixosModule
          ./nixos/all-systems-configuration.nix
          ./nixos/kronos/hardware-configuration.nix
          ./nixos/kronos/configuration.nix
          ./nixos/wifiNetworks.nix
        ];
      };
    };
    kronos-sd = nixosConfigurations.kronos.config.system.build.sdImage;
    # `home-manager switch --flake .#ari`
    homeConfigurations =
      let
        graphics = home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs; inherit nix-colors; };
            modules = [
              inputs.nix-colors.homeManagerModules.default
              inputs.gBar.homeManagerModules.x86_64-linux.default
              ./home-manager/home.nix
              ./home-manager/home-graphical.nix
            ];
          };
        nographics = home-manager.lib.homeManagerConfiguration
          {
            pkgs = nixpkgs.legacyPackages.aarch64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/home.nix
            ];
          };
      in
      {
        "ari" = graphics;
        "ari-tty" = nographics;
      };
  };
}
