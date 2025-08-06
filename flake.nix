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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };
    vscode-ext = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
    vscode-server = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-vscode-server";
    };
  };
  nixConfig = {
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}