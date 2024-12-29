_default:
  @just --list --unsorted

genflake:
  nix run .#genflake flake.nix
  
build *args: genflake
  sudo bash -c 'nixos-rebuild build --flake . {{args}} |& nom'
  nvd diff /run/current-system ./result

switch *args: genflake
  sudo bash -c 'nixos-rebuild switch --flake . {{args}} |& nom'

update:
  nix flake update

check:
  nix flake check

clean:
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
  sudo nix-collect-garbage --delete-older-than 3d

fmt:
  nix fmt .