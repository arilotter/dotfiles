# Do not modify! This file is generated.

{
  description = "ari's nice lil nix config :3";
  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    beepy = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:arilotter/nixos-beepy";
    };
    fido2-hid-bridge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:arilotter/fido2-hid-bridge";
    };
    flakegen.url = "github:jorsn/flakegen";
    fw-inputmodule = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:caffineehacker/nix?dir=flakes/inputmodule-rs";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hypr-contrib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/contrib";
    };
    lix-module = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    nur.url = "github:nix-community/NUR";
    vscode-ext = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
  };
  nixConfig = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o=" "ari-sol-builder-1:PBsq1rU3Xd/S+N3GatIWi82PFoeOqQdpaArZTns69aM=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}