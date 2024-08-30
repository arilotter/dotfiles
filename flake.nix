{
  description = "ari's nice lil nix config :3";

  nixConfig = {
    extra-substituters = ["https://raspberry-pi-nix.cachix.org"];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "ari-sol-builder-1:PBsq1rU3Xd/S+N3GatIWi82PFoeOqQdpaArZTns69aM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

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

    fw-inputmodule = {
      url = "github:caffineehacker/nix?dir=flakes/inputmodule-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nur,
    nixpkgs,
    home-manager,
    nix-colors,
    agenix,
    ...
  } @ inputs: let
    sys = {
      specialArgs = {
        inherit inputs;
        inherit nix-colors;
      };
    };
    mods = [
      agenix.nixosModules.default
      nur.nixosModules.nur
      ./nixos/all-systems-configuration.nix
    ];
    graphical-mods = mods ++ [./nixos/graphical-configuration.nix];
  in rec {
    nixosConfigurations = {
      # desktop ~
      "luna" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            graphical-mods
            ++ [
              ./nixos/luna/hardware-configuration.nix
              ./nixos/luna/configuration.nix
            ];
        }
      );

      # framework laptop
      "hermes" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            graphical-mods
            ++ [
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              ./nixos/hermes/hardware-configuration.nix
              ./nixos/hermes/configuration.nix
            ];
        }
      );

      # kronos = saturn = cuz it rings ;)
      # sd image: `nix build '.#kronos-sd'`
      # from another pc: `NIX_SSHOPTS="-t" nixos-rebuild boot --flake .#kronos -L --target-host ari@kronos.local --use-remote-sudo`
      "kronos" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            mods
            ++ [
              inputs.beepy.nixosModule
              ./nixos/kronos/hardware-configuration.nix
              ./nixos/kronos/configuration.nix
              ./nixos/wifiNetworks.nix
            ];
        }
      );

      # server = sol
      # locally: `sudo nixos-rebuild switch --flake .`
      # from `another pc: `NIX_SSHOPTS="-t" nixos-rebuild switch --flake .#sol -L --target-host ari@sol.local --use-remote-sudo`
      "sol" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            mods
            ++ [
              inputs.nixos-hardware.nixosModules.hardkernel-odroid-h3
              ./nixos/sol/hardware-configuration.nix
              ./nixos/sol/configuration.nix
            ];
        }
      );
    };
    kronos-sd = nixosConfigurations.kronos.config.system.build.sdImage;
    # `home-manager switch --flake .#ari`
    homeConfigurations = let
      graphics = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          inherit nix-colors;
        };
        modules = [
          inputs.nix-colors.homeManagerModules.default
          ./home-manager/home.nix
          ./home-manager/home-graphical.nix
        ];
      };
      nographics = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [./home-manager/home.nix];
      };
    in {
      "ari" = graphics;
      "ari-tty" = nographics;
    };
  };
}
