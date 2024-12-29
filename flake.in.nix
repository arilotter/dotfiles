{
  description = "ari's nice lil nix config :3";

  nixConfig = {
    extra-substituters = ["https://raspberry-pi-nix.cachix.org" "https://cache.garnix.io"];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "ari-sol-builder-1:PBsq1rU3Xd/S+N3GatIWi82PFoeOqQdpaArZTns69aM="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = let
    followsNixpkgs = url: {
      inherit url;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  in {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";

    agenix = followsNixpkgs "github:ryantm/agenix";
    home-manager = followsNixpkgs "github:nix-community/home-manager";
    hypr-contrib = followsNixpkgs "github:hyprwm/contrib";
    vscode-ext = followsNixpkgs "github:nix-community/nix-vscode-extensions";
    beepy = followsNixpkgs "github:arilotter/nixos-beepy";
    fido2-hid-bridge = followsNixpkgs "github:arilotter/fido2-hid-bridge";
    fw-inputmodule = followsNixpkgs "github:caffineehacker/nix?dir=flakes/inputmodule-rs";
    nixvim = followsNixpkgs "github:nix-community/nixvim";
    lix-module = followsNixpkgs "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
  };

  outputs = {
    nur,
    nixpkgs,
    home-manager,
    nix-colors,
    agenix,
    fido2-hid-bridge,
    lix-module,
    ...
  } @ inputs: let
    sys = {
      specialArgs = {
        inherit inputs;
        inherit nix-colors;
      };
    };
    base-modules = [
      lix-module.nixosModules.default
      agenix.nixosModules.default
      nur.modules.nixos.default
      fido2-hid-bridge.nixosModule
      home-manager.nixosModules.home-manager
      {home-manager.extraSpecialArgs = {inherit inputs;};}
      ./nixos/all-systems-configuration.nix
    ];
    tty-modules =
      base-modules
      ++ [
        {
          home-manager.users.ari = import ./home-manager/home.nix;
        }
      ];
    graphical-modules =
      base-modules
      ++ [
        ./nixos/graphical-configuration.nix
        {
          home-manager.users.ari = import ./home-manager/home-graphical.nix;
        }
      ];
  in rec {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    nixosConfigurations = {
      # desktop ~
      "luna" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            graphical-modules
            ++ [
              ./nixos/luna/hardware-configuration.nix
              ./nixos/luna/configuration.nix
              ./nixos/mount-sol-samba-share.nix
            ];
        }
      );

      # framework laptop
      "hermes" = nixpkgs.lib.nixosSystem (
        sys
        // {
          modules =
            graphical-modules
            ++ [
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              ./nixos/hermes/hardware-configuration.nix
              ./nixos/hermes/configuration.nix
              ./nixos/mount-sol-samba-share.nix
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
            tty-modules
            ++ [
              inputs.beepy.nixosModule
              ./nixos/kronos/hardware-configuration.nix
              ./nixos/kronos/configuration.nix
              ./nixos/mount-sol-samba-share.nix
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
            tty-modules
            ++ [
              inputs.nixos-hardware.nixosModules.hardkernel-odroid-h3
              ./nixos/sol/hardware-configuration.nix
              ./nixos/sol/configuration.nix
            ];
        }
      );
    };
    kronos-sd = nixosConfigurations.kronos.config.system.build.sdImage;
  };
}
